module PatientsHelper
  def payment_status_viewer(payment_status)
    if (payment_status.upcase == "CHECK WAITING" || payment_status.upcase == "CHECK WAITING FOR FULL PAYMENT" rescue false )
      content_tag( :a, payment_status.upcase, class: "label label-warning")
    elsif (payment_status.upcase == "CHECK AVAILABLE" rescue false)
      content_tag( :a, payment_status.upcase, class: "label label-info")
    elsif (payment_status.upcase == "FULLY PAID" rescue false)
      content_tag( :a, payment_status.upcase, class: "label label-success")
    else
      content_tag( :a, (payment_status.upcase rescue nil), class: "label label-default")
    end
  end
  
  def edit_patient_buttons_helper(patient)
    state = patient.state
    if (can?(:edit, patient)) && (state.upcase == "PICTURE_UPLOADED" rescue false )
      content_tag( :a, href: edit_patient_path(patient), class: "btn btn-primary btn-sm btn-outline", title: "Create Patient Record", "data-toggle": "tooltip") do
        # content_tag :span, "", class: "fa fa-edit"
        content_tag :span, "Edit"
      end
    elsif (can?(:edit, patient)) && (state.upcase == "RECORD_CREATED" rescue false)
      content_tag( :a, href: edit_patient_path(patient), class: "btn btn-primary btn-sm btn-outline", title: "Edit Patient Record", "data-toggle": "tooltip") do
        content_tag :span, "", class: "fa fa-edit"
      end
    end
  end

  def check_buttons_helper(patient)
    if (can?(:check_available, patient)) && patient.is_check_waiting?
      content_tag( :a, href: check_available_patient_path(patient), class: "btn btn-primary btn-sm btn-outline", title: "Mark Check Available", "data-toggle": "tooltip", data: { method: :put, confirm: "Are you sure you want to mark the payment status of Patient: #{patient.full_name} as CHECK AVAILABLE?", "action-type": "Check Available" }) do
        content_tag :span, "", class: "fa fa-money-check"
      end

    elsif (can?(:make_payment, patient)) && patient.is_check_available?
      content_tag( :a, href: make_payment_patients_path(id: patient.id), class: "btn btn-primary btn-sm btn-outline", method: :get, title: "Make Payment", "data-toggle": "tooltip") do
        content_tag :span, "", class: "fa fa-piggy-bank"
      end
    end
  end
end
