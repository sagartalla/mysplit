class Group < ActiveRecord::Base
  has_many :memberships
  has_many :users, :through => :memberships

  has_many :bills

  #returns the index of min negative payment in each_person
  def findMaxCreditor
    @balance_graph.index(@balance_graph.min { |a,b| a[:balance] <=> b[:balance] })
  end

  def findMaxDebator
    @balance_graph.index(@balance_graph.max { |a,b| a[:balance] <=> b[:balance] })
  end

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

    @balance_graph = []

    users.each do |user|
      @balance_graph << {
        user_id: user.id,
        balance: each_share - each_payment["#{user.id}".to_sym]
      }
    end

    weighted_graph = []

    i = 0
    num = @balance_graph.size
    
    while i < num - 1 

      max_creditor = findMaxCreditor
      max_debitor = findMaxDebator
      delete_debitor = false
      delete_creditor = false

      node = {
          node_1: @balance_graph[max_debitor][:user_id],
          node_2: @balance_graph[max_creditor][:user_id],
        }

      transfer = [@balance_graph[max_debitor][:balance], @balance_graph[max_creditor][:balance].abs].min
      node[:weight] = transfer
      
      if @balance_graph[max_debitor][:balance] == transfer
        @balance_graph[max_creditor][:balance] += transfer
        delete_debitor = true
      end

      if @balance_graph[max_creditor][:balance].abs == transfer
        @balance_graph[max_debitor][:balance] -= transfer
        delete_creditor = true
      end

      @balance_graph.delete_at max_debitor if delete_debitor
      @balance_graph.delete_at max_creditor if delete_creditor

      weighted_graph << node
      
      i+=1

    end    

    weighted_graph
  end
end
