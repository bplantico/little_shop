FactoryBot.define do

  factory :order, class: Order do
    user
    status { :pending }

    after(:create) do |order|
      order.address_id = order.user.addresses[0].id
    end
  end

  factory :packaged_order, parent: :order do
    user
    status { :packaged }

    after(:create) do |order|
      order.address_id = order.user.addresses[0].id
    end
  end

  factory :shipped_order, parent: :order do
    user
    status { :shipped }

    after(:create) do |order|
      order.address_id = order.user.addresses[0].id
    end
  end

  factory :cancelled_order, parent: :order do
    user
    status { :cancelled }

    after(:create) do |order|
      order.address_id = order.user.addresses[0].id
    end
  end
  
end
