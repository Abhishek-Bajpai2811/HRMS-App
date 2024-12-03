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

#   def update
#     # If the return date is provided, update it
#     #DEASSIGN
#     @issued_item = IssuedItem.find(params[:id])
#     if params[:issued_item][:returned_at].present?
#       @issued_item.update(issued_at: nil, returned_at: params[:issued_item][:returned_at])
#       # @issued_item.update(returned_at: nil, assign_at: params[:issued_item][:issued_at])
    
#         if @issued_item.save
#           @issued_item.item.increment!(:quantity) # Increment the item quantity once it's issued again
          
#         else
#           render :edit, alert: "Failed to update issued item."
#           return
        
#       end
    
#     end
#     if @issued_item.update(issued_item_params)
#       if @issued_item.issued_at.present?
#         @issued_item.update(returned_at: nil, issued_at: params[:issued_item][:returned_at][:employee_id])

#         # @issued_item.item.increment!(:quantity)  # Increment the item quantity once it's returned
#         redirect_to issued_items_path, notice: "Issued item updated successfully."
#       # end
#       # redirect_to issued_items_path, notice: "Issued item updated successfully."
#     else
#       render :edit
#     end
#   end
# end

#NEW UPDATE METHOD GPT

def update
  @issued_item = IssuedItem.find(params[:id])

  # **Deassign Logic**: If a return date is provided
 
  if params[:issued_item][:returned_at].present?
    if @issued_item.update(issued_at: nil, returned_at: params[:issued_item][:returned_at], employee_id: nil)
    
      @issued_item.item.increment!(:quantity) # Increment item quantity when returned
      flash[:notice] = "Item deassigned successfully."
    else
      flash[:alert] = "Failed to deassign the item."
      render :edit and return
    end

end

  # **Reassign Logic**: If `issued_at` is provided and we want to reassign the item
  if params[:issued_item][:issued_at].present?
    if @issued_item.update(returned_at: nil, issued_at: params[:issued_item][:issued_at], employee_id: params[:issued_item][:employee_id])
      @issued_item.item.decrement!(:quantity) # Decrement item quantity when reassigned
      flash[:notice] = "Item reassigned successfully."
    else
      flash[:alert] = "Failed to reassign the item."
      render :edit and return
    end
  end

  # Redirect to issued items path after update
  redirect_to issued_items_path
end


#DESTROY METHOD

 
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
