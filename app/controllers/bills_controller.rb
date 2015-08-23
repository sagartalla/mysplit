class BillsController < ApplicationController
  
  before_action :is_member

  def index
    @bills = Group.find(params[:group_id]).bills
  end
  
  def new
    @members = Group.find(params[:group_id]).users
  end

  def create
    new_bill = Bill.create(bill_params)
    new_bill.group = Group.find(params[:group_id])
    new_bill.save
    redirect_to group_bills_path
  end

  def edit
    @bill = Bill.find(params[:id])
    @members = @bill.group.users
  end

  def update
    @bill = Bill.find(params[:id])
    @bill.update!(bill_params)
    redirect_to group_bills_path(@bill.group)
  end

private
  def bill_params
    params.require(:bill).permit(:item, :amount, :user_id)
  end
  
  def is_member
    group = params[:group_id] ? Group.find(params[:group_id]) : Bill.find(params[:id]).group
    unless group.users.exists?(current_user)
      flash[:error] = "You are not a member of the group"
      redirect_to groups_path
    end
  end
end
