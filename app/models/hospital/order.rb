class Hospital::Order < ApplicationRecord

	belongs_to :encounter, class_name: '::Hospital::Encounter', foreign_key: 'encounter_id', optional: true
	# has_one :dict_medication, class_name: '::Dict::Medication', foreign_key: 'order_id' 

	belongs_to :prescription, class_name: '::Hospital::Prescription', foreign_key: 'prescription_id', optional: true
	belongs_to :author, class_name: '::User', foreign_key: 'author_id', optional: true

	# order_type 医嘱类型 1 药品医嘱


	def dict_medication
		::Dict::Medication.find(self.serialno)
	end

	def to_web_front
		ret = {
			id: self.id,
			serialno: self.serialno,
			title: self.title,
			specification: self.specification,
			single_qty: {
				value: self.single_qty_value,
				unit: self.single_qty_unit
			},
			dose: {
				value:self.dose_value,
				unit: self.dose_unit
			},
			route:{
				code: self.route_code,
				display: self.route_display
			},
			frequency:{
				code: self.frequency_code,
			    display: self.frequency_display
			},
			course_of_treatment:{
				value: self.course_of_treatment_value,
				unit: self.course_of_treatment_unit
			},
			total_quantity: self.total_quantity,
			unit: self.unit,
			price: self.price,
			note: self.note,
			status: self.status,
			order_type: self.order_type,
			encounter_id: self.encounter_id,
			author: {
				id: self.author.id,
				display: self.author.name
			}
		}
	end
	class<<self
		def copy_orders(order_ids, encounter_id, cur_user)
			cur_encounter = ::Hospital::Encounter.find(encounter_id)
			cur_orders = ::Hospital::Order.find(order_ids)
			p cur_orders
			::ActiveRecord::Base.transaction do 
				cur_orders.each do |_order|
					# 三方面复制  复制药品使用信息  复制当前药品的价格  置空相关医嘱和人相关的信息
					new_order = _order.clone
					new_order.status = "N"
          new_order.encounter_id = encounter_id
          new_order.author_id = cur_user.id
          new_order.prescription_id = nil
          new_order.save!
				end
			end
		end
	end




end