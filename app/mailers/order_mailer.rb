class OrderMailer < ApplicationMailer
  default from: Settings.mailer.from

  def send_mail(action)
    @order = Order.find_by(id: params[:order])
    mail(to: @order.user.email, subject: t("mailer.subject.#{action}_order")) if @order
  end

  [:confirm, :place, :reject].each do |action|
    define_method("#{action}_order") do
      send_mail(action)
    end
  end
end
