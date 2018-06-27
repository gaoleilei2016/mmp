class CreateHealthcloudTables < ActiveRecord::Migration[5.1]
	def change
		# 1
		create_table :health_cloud_ws_bloods do |t|
			t.integer :intServerID
			t.string :datRecordTime
			t.integer :intSystolic
			t.integer :intDiastolic
			t.integer :intPulse
			t.integer :intTypeID
			t.string :strMeno
			t.string :userid
			t.string :strPrgID
			t.string :strUserAccount
			t.timestamps
		end
		# 2
		create_table :health_cloud_ws_blood_sugars do |t|
			t.integer :intServerID
			t.string :datRecordTime
			t.integer :intConsistency
			t.string :intTypeID
			t.string :strMemo
			t.string :userid
			t.string :strPrgID
			t.string :strUserAccount
			t.timestamps
		end
		# 3
		create_table :health_cloud_ws_diets do |t|
			t.integer :intServerID
			t.string :datRecordTime
			t.integer :intDietType
			t.string :img1
			t.string :img2
			t.string :img3
			t.string :img4
			t.string :img5
			t.integer :img6
			t.string :img7
			t.integer :img8
			t.string :img9
			t.string :strMemo
			t.string :userid
			t.string :strPrgID
			t.string :strUserAccount
			t.timestamps
		end
		# 4
		create_table :health_cloud_ws_ecg_breaths do |t|
			t.integer :intServerID
			t.string :datRecordTime
			t.integer :intRecordLevel
			t.integer :intTrainingTime
			t.integer :intAvgHR
			t.integer :intMaxHR
			t.integer :intMinHR
			t.string :strMemo
			t.string :userid
			t.string :strPrgID
			t.string :strUserAccount
			t.timestamps
		end
		# 5
		create_table :health_cloud_ws_ecg_hearts do |t|
			t.integer :intServerID
			t.string :datRecordTime
			t.integer :intHeartbeat
			t.integer :intPressure
			t.integer :intVitalityAge
			t.integer :intEmoIndex
			t.string :strMemo
			t.string :userid
			t.string :strPrgID
			t.string :strUserAccount
			t.timestamps
		end
		# 6
		create_table :health_cloud_ws_hearts do |t|
			t.integer :intServerID
			t.string :datRecordTime
			t.integer :strHR
			t.integer :strMemo
			t.integer :userid
			t.integer :strPrgID
			t.string :strUserAccount
			t.timestamps
		end
		# 7
		create_table :health_cloud_ws_heart_vts do |t|
			t.string :HRIndex
			t.string :HRValue
			t.string :intServerID
			t.string :strMemo
			t.string :userid
			t.string :strPrgID
			t.string :strRecordDate
			t.string :strUserAccount
			t.timestamps
		end
		# 8
		create_table :health_cloud_ws_logs do |t|
			t.string :method
			t.string :info
			t.string :time
			t.string :error
			t.timestamps
		end
		# 9
		create_table :health_cloud_ws_members do |t|
			t.integer :intServerID
			t.boolean :bolisMale
			t.float :floHeight
			t.string :datStartdate
			t.string :datEnddate
			t.float :floFtweight
			t.float :floTgweight
			t.float :floFtBodyFat
			t.float :floTgBodyFat
			t.float :floFtWaistline
			t.float :floTgWaistline
			t.float :floFtButtocks
			t.float :floTgButtocks
			t.integer :intSportCount
			t.integer :intSportOneMin
			t.string :datBreakfristST
			t.string :datBreakfristET
			t.string :datLunchST
			t.string :datLunchET
			t.string :datDinnerST
			t.string :datDinnerET
			t.string :datForbiddenST1
			t.string :datForbiddenET1
			t.string :datForbiddenST2
			t.string :datForbiddenET2
			t.integer :intActivity
			t.integer :intRreducingCalorie
			t.string :userid
			t.string :strPrgID
			t.string :strUserAccount
			t.timestamps
		end
		# 10
		create_table :health_cloud_ws_questions do |t|
			t.integer :intQuestionID
			t.string :strContent
			t.string :userid
			t.string :strPrgID
			t.string :strUserAccount
			t.timestamps
		end
		# 11
		create_table :health_cloud_ws_rings do |t|
			t.string :intSportType
			t.string :strAutoMeasure
			t.string :strMemo
			t.string :userid
			t.string :strPrgID
			t.string :strUserAccount
			t.string :serverId
			t.string :recordTime
			t.string :footSteps
			t.string :sportMinutes
			t.string :distance
			t.string :calorie
			t.timestamps
		end
		# 12
		create_table :health_cloud_ws_sleeps do |t|
			t.string :datStartTime
			t.string :datEndTime
			t.integer :intDeepMinutes
			t.integer :intLightMinutes
			t.string :strSleepRawData
			t.integer :intServerID
			t.string :userid
			t.string :strPrgID
			t.string :strUserAccount
			t.timestamps
		end
		# 13
		create_table :health_cloud_ws_sleep_vts do |t|
			t.string :datStartTime
			t.string :datEndTime
			t.integer :intDeepMinutes
			t.integer :intLightMinutes
			t.integer :intAwakeMinutes
			t.string :sleepTime
			t.string :sleepLevel
			t.integer :intServerID
			t.string :userid
			t.string :strPrgID
			t.string :strUserAccount
			t.timestamps
		end
		# 14
		create_table :health_cloud_ws_sports do |t|
			t.integer :intServerID
			t.string :datRecordTime
			t.string :intSportType
			t.integer :intSportMinutes
			t.float :dubDistance
			t.integer :intFootSteps
			t.integer :intCalorie
			t.string :strAutoMeasure
			t.string :strMemo
			t.string :img1
			t.string :img2
			t.string :img3
			t.string :img4
			t.string :img5
			t.string :img6
			t.string :img7
			t.string :img8
			t.string :img9
			t.string :userid
			t.string :strPrgID
			t.string :strUserAccount
			t.timestamps
		end
		# 15
		create_table :health_cloud_ws_sys do |t|
			t.string :strPrgID
			t.string :strPrgPws
			t.string :company
			t.timestamps
		end
		# 16
		create_table :health_cloud_ws_users do |t|
			t.string :strUserAccount
			t.string :strDisplayName
			t.string :bolisMale
			t.boolean :bolisAgreement
			t.string :strCell
			t.string :strEMail
			t.string :strPassword
			t.string :UserPhoto
			t.string :strBirthday
			t.string :strAddSecCode
			t.string :strCommunityCode
			t.integer :intUserID
			t.timestamps
		end
		# 17
		create_table :health_cloud_ws_weights do |t|
			t.integer :intServerID
			t.string :datRecordTime
			t.float :floWeight
			t.float :floBodyFat
			t.float :floWaistline
			t.float :floButtocks
			t.float :floRateOfBone
			t.float :floSoftLeanMass
			t.float :floTotalBodyWater
			t.float :floBMR
			t.float :floVisceralFat
			t.float :floPhysicalAge
			t.string :userid
			t.string :strPrgID
			t.string :strUserAccount
			t.timestamps
		end
	end
end
