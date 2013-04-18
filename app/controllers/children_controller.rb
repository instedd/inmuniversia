class ChildrenController < ApplicationController
  before_filter :authenticate_subscriber!
  
  before_filter :load_children, only: [:index]
  before_filter :load_child, only: [:show, :edit, :update, :destroy]

  # GET /children
  # GET /children.json
  def index
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @children }
    end
  end

  # GET /children/1
  # GET /children/1.json
  def show
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @child }
    end
  end

  # GET /children/new
  # GET /children/new.json
  def new
    @child = current_subscriber.children.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @child }
    end
  end

  # GET /children/1/edit
  def edit
  end

  # POST /children
  # POST /children.json
  def create
    @child = current_subscriber.children.new(params[:child])

    respond_to do |format|
      if @child.save
        
        # TODO: Move to callbacks?
        @child.create_vaccinations!
        @child.subscribe!

        format.html { redirect_to @child, notice: 'Child was successfully created.' }
        format.json { render json: @child, status: :created, location: @child }
      else
        format.html { render action: "new" }
        format.json { render json: @child.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /children/1
  # PUT /children/1.json
  def update
    respond_to do |format|
      if @child.update_attributes(params[:child])
        format.html { redirect_to @child, notice: 'Child was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @child.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /children/1
  # DELETE /children/1.json
  def destroy
    @child.destroy

    respond_to do |format|
      format.html { redirect_to children_url }
      format.json { head :no_content }
    end
  end

  protected

  def load_children
    @children = current_subscriber.children
  end

  def load_child
    @child = current_subscriber.children.find(params[:id])
  end
end
