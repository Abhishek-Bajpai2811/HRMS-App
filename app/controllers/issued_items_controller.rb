# class IssuedItemsController < ApplicationController
#   before_action :authenticate_user!
#   before_action :set_issued_item, only: [:show, :edit, :update, :destroy]

#   def index
#     # Admin can see all issued items, HR can see total issued items, Employees can see their issued items
#     if current_user.admin?
#       @issued_items = IssuedItem.all
#     elsif current_user.hr?
#       @issued_items = IssuedItem.all # Modify this to show aggregated data if needed
#     elsif current_user.employee?
#       @issued_items = IssuedItem.where(employee_id: current_user.employee.id)
#     else
#       @issued_items = []
#     end
#   end

#   def show
#     # Everyone with access can view details of a specific issued item
#   end

#   def new
#     # Only Admin can issue new items
#     if current_user.admin?
#       @issued_item = IssuedItem.new
#     else
#       redirect_to issued_items_path, alert: "You are not authorized to issue items."
#     end
#   end

#   def create
#     # Only Admin can issue items
#     Rails.logger.debug "Issued Item Params: #{params.inspect}"
#     @issued_item = IssuedItem.new(issued_item_params)

#     if @issued_item.save
#       redirect_to issued_items_path, notice: "Item issued successfully."
#     else
#       flash[:alert] = @issued_item.errors.full_messages.to_sentence
#       render :new
#     end
#   end

#   def edit
#     # Only Admin can edit issued items
#     unless current_user.admin?
#       redirect_to issued_items_path, alert: "You are not authorized to edit issued items."
#     end
#   end

#   def update
#     # Only Admin can update issued items
#     if current_user.admin?
#       if @issued_item.update(issued_item_params)
#         redirect_to issued_items_path, notice: "Issued item updated successfully."
#       else
#         flash[:alert] = @issued_item.errors.full_messages.to_sentence
#         render :edit
#       end
#     else
#       redirect_to issued_items_path, alert: "You are not authorized to update issued items."
#     end
#   end

#   def destroy
#     # Only Admin can delete issued items
#     if current_user.admin?
#       @issued_item.destroy
#       redirect_to issued_items_path, notice: "Issued item deleted successfully."
#     else
#       redirect_to issued_items_path, alert: "You are not authorized to delete issued items."
#     end
#   end

#   private

#   def set_issued_item
#     @issued_item = IssuedItem.find(params[:id])
#   rescue ActiveRecord::RecordNotFound
#     redirect_to issued_items_path, alert: "Issued item not found."
#   end

#   def issued_item_params
#     params.require(:issued_item).permit(:item_id, :employee_id, :quantity, :issued_date, :return_date)
#   end
# end

class IssuedItemsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_issued_item, only: [:destroy, :show, :edit, :update]

  def index

    # Admin and HR can see all issued items
    if current_user.admin? || current_user.hr?
      @issued_items = IssuedItem.includes(:item, :employee)
    # Employees can only see their own issued items
    elsif current_user.employee?
     
      @issued_items = current_user.employee.issued_items
    end
  end

  def new
    # Only Admin can issue items
    if current_user.admin?
      @issued_item = IssuedItem.new
      @employees = Employee.all
      @items = Item.where("quantity > ?", 0)  # Only show items that are available
    else
      redirect_to issued_items_path, alert: "You don't have permission to issue items."
    end
  end

  def create
    @issued_item = IssuedItem.new(issued_item_params)
    @issued_item.issued_by = current_user.id  # Set the user who issued the item
    @issued_item.issued_at = Time.current     # Set the current time as the issued date

    if @issued_item.save
      @issued_item.item.decrement!(:quantity)  # Decrement the quantity of the issued item
      redirect_to issued_items_path, notice: "Item issued successfully."
    else
      flash[:alert] = @issued_item.errors.full_messages.to_sentence
      render :new
    end
  end

  def show
    # Show details of a specific issued item
  end

  def edit
    @items = Item.all
    @employees = Employee.all
  end

  def update
    # If the return date is provided, update it
    if @issued_item.update(issued_item_params)
      if @issued_item.returned_at.present?
        @issued_item.item.increment!(:quantity)  # Increment the item quantity once it's returned
      end
      redirect_to issued_items_path, notice: "Issued item updated successfully."
    else
      render :edit
    end
  end
 
  def destroy
    @issued_item = IssuedItem.find(params[:id])
    # Only admin can delete
    if current_user.admin?
    #   @issued_item.item.increment!(:quantity) if @issued_item.returned_at.nil?
      @issued_item.destroy
      redirect_to issued_items_path, notice: "Issued item record deleted."
    else
      redirect_to issued_items_path, alert: "You don't have permission to delete this record."
    end
  end
  
  

  private

  def set_issued_item
    @issued_item = IssuedItem.find(params[:id])
  end

  def issued_item_params
    # Ensure you're using the correct field names in the permitted parameters
    params.require(:issued_item).permit(:item_id, :employee_id, :issued_at, :returned_at)
  end
end
