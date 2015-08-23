class Group < ActiveRecord::Base
  has_many :memberships
  has_many :users, :through => :memberships

  has_many :bills

  def split_expences
    total_expences = 0
    each_share = 0
    each_payment = {}

    users.each do |user|
      each_payment["#{user.id}".to_sym] = 0
    end    

    bills.each do |bill|
      total_expences += bill.amount
      each_payment["#{bill.paid_by.id}".to_sym] = bill.amount
    end

    each_share = total_expences / users.size

    balance_graph = []

    users.each do |user|
      balance_graph << {
        user_id: user.id,
        balance: each_share - each_payment["#{user.id}".to_sym]
      }
    end

    weighted_graph = []

    i = 0
    num = balance_graph.size
    while i < num - 1
      node_1 = balance_graph[i]
      node_2 = balance_graph[i+1]
      weight = node_1[:balance]
      node_2[:balance] += node_1[:balance]

      weighted_graph << {
        node_1: node_1[:user_id],
        node_2: node_2[:user_id],
        weight: weight
      }

      i+=1;
    end

    weighted_graph
  end
end
