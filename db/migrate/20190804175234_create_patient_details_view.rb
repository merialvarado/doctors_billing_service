class CreatePatientDetailsView < ActiveRecord::Migration[5.2]


# Patient(id: uuid, first_name: string, middle_name: string, 
#   surname: string, patient_num: string, date_admitted: date, contact_num: string, 
#   created_at: datetime, updated_at: datetime, doctor_id: uuid, 
#   hospital_id: uuid, billing_amount: decimal, payment_status: string, 
#   balance: decimal, hmo_id: uuid, patient_picture: string, remarks: text,
#   state: string, payment_method: string, date_paid: date, procedure_date: date, 
#   surgeon_id: uuid, procedure_type_id: uuid)

  def up
    execute "
      CREATE VIEW patient_details AS
        SELECT
          p.id,
          concat(p.first_name, ' ', p.middle_name, ' ', p.surname) as full_name,
          p.patient_num,
          p.date_admitted,
          p.contact_num,
          p.billing_amount,
          p.balance,
          p.payment_status,
          (p.billing_amount - p.balance) as collected_amount,
          p.remarks,
          p.state,
          p.date_paid,
          p.procedure_date,
          p.payment_method,
          p.created_at,
          p.updated_at,
          (SELECT users.full_name from users WHERE users.id = p.doctor_id) as doctor,
          (SELECT hospitals.name from hospitals WHERE hospitals.id = p.hospital_id) as hospital,
          (SELECT surgeons.full_name from surgeons WHERE surgeons.id = p.surgeon_id) as surgeon,
          (SELECT procedure_types.name from procedure_types WHERE procedure_types.id = p.procedure_type_id) as procedure_type,
          (
            CASE 
              WHEN p.payment_method = 'HMO'
            THEN
              (SELECT hmos.name from hmos where hmos.id = p.hmo_id)
            ELSE
              p.payment_method
            END
           ) as insurance
        FROM
          patients p;
    "
  end

  def down
    execute "DROP VIEW patient_details"
  end
end

