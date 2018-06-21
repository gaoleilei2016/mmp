class NoticeBroadcastJob < ApplicationJob
  queue_as :default
 
  def perform(message)
  	p "_______________perform_________________\n"
    p message
    data = {flag:true, info:"新订单", org_id:"34", status:"2", order_id:"12", created_at:Time.new.strftime("%Y-%m-%d %H:%M"), order_code:"D54235822", patient_name:"提示", amt:"23"}
    ActionCable.server.broadcast 'notice_channel', data:data
  end
 
  private
    def render_message(message)
    	p "message_____________#{message}___________render_message"
      ApplicationController.renderer.render(partial: 'messages/wait_patient', locals: { wait_patient: message })
    end
end
