class NoticeBroadcastJob < ApplicationJob
  queue_as :default
 
  def perform(message)
  	p "_______________perform_________________\n"
    p message[:data]
    ActionCable.server.broadcast 'notice_channel', data:message[:data]
  end
 
  private
    def render_message(message)
    	p "message_____________#{message}___________render_message"
      ApplicationController.renderer.render(partial: 'messages/wait_patient', locals: { wait_patient: message })
    end
end
