(::User.create(login:'admin',password:'111111',email:'admin@tenmind.com') if ::User.where(login:'admin').count==0) rescue nil
::Orders::Order.check_order_timer rescue nil
