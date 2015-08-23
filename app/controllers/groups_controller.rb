class GroupsController < ApplicationController
  def index
    @groups = current_user.groups
  end

  def new
    @users = User.all_except(current_user)
  end

  def create
    new_grp = Group.create(group_params)
    new_grp.users << current_user
    members = params[:members]
    members.each do |meb|
      new_grp.users << User.find(meb)
    end
    redirect_to groups_path
  end

  def show
    redirect_to group_bills_path(params[:id])
  end
  
  def show_split
    group = Group.find(params[:id])
    @share_report = group.split_expences
  end

  def destroy
    @group = Group.find(params[:id])
    @group.memberships.destroy_all
    @group.destroy
    redirect_to groups_path
  end

private
  def group_params
    params.require(:group).permit(:name, :summary)
  end
end
