class InviteMailer < Devise::Mailer

  def guest_invitation_instructions(record, opts={})
    devise_mail(record, :guest_invitation_instructions, opts)
  end

  def friend_invitation_instructions(record, opts={})
    devise_mail(record, :friend_invitation_instructions, opts)
  end

end