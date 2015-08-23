class GroupsController < ApplicationController
  
  before_action :is_member, :except => [:index, :new, :create]

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
    @group = Group.find(params[:id])
    graph = @group.split_expences

    @viewer = current_user
    @other_members = @group.users.all_except(current_user)
    @payements = []
    @other_members.each do |mem|
      link = graph.detect { |node|
        (node[:node_1] == mem.id && node[:node_2] == current_user.id) || (node[:node_1] == current_user.id && node[:node_2] == mem.id)
      }
      if link.nil?
        @payements << "0"
      elsif link[:node_1] == current_user.id
        @payements << "Pay: #{link[:weight]}"
      else
        @payements << "Get: #{link[:weight]}"
      end
    end
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

  def is_member
    group = Group.find(params[:id])
    unless group.users.exists?(current_user)
      flash[:error] = "You are not a member of the group"
      redirect_to groups_path
    end
  end

end
