module PatientsHelper
	def payment_status_viewer(payment_status)
		if (payment_status.upcase == "CHECK WAITING" || payment_status.upcase == "CHECK WAITING FOR FULL PAYMENT" rescue false )
			content_tag( :a, payment_status, class: "label label-warning")
		elsif (payment_status.upcase == "CHECK AVAILABLE" rescue false)
			content_tag( :a, payment_status, class: "label label-info")
		elsif (payment_status.upcase == "FULLY PAID" rescue false)
			content_tag( :a, payment_status, class: "label label-success")
		else
			content_tag( :a, payment_status, class: "label label-default")
		end
	end
end
