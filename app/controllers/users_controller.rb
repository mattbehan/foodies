class UsersController < ApplicationController
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.

  def show
  end

  def hey
  end

  def index
  end

  def invite
  	resource = User.new
  end

end

        def _invite_reviewer(attributes={}, invited_by=nil, &block)
          invite_key_array = invite_key_fields
          attributes_hash = {}
          invite_key_array.each do |k,v|
            attribute = attributes.delete(k)
            attribute = attribute.to_s.strip if strip_whitespace_keys.include?(k)
            attributes_hash[k] = attribute
          end

          invitable = find_or_initialize_with_errors(invite_key_array, attributes_hash)
          invitable.assign_attributes(attributes)
          invitable.invited_by = invited_by
          unless invitable.password || invitable.encrypted_password.present?
            invitable.password = random_password
          end

          invitable.valid? if self.validate_on_invite
          if invitable.new_record?
            Role.create(user_id: invitable.id, name: "reviewer")
            invitable.clear_errors_on_valid_keys if !self.validate_on_invite
          elsif !invitable.invited_to_sign_up? || !self.resend_invitation
            invite_key_array.each do |key|
              invitable.errors.add(key, :taken)
            end
          end

          yield invitable if block_given?
          mail = invitable.invite! if invitable.errors.empty?
          [invitable, mail]
        end