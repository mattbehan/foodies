class InviteMailer < Devise::Mailer

  def user_invitation_instructions(record, opts={})
    devise_mail(record, :user_invitation_instructions, opts)
  end

  def reviewer_invitation_instructions(record, opts={})
    devise_mail(record, :reviewer_invitation_instructions, opts)
  end

end