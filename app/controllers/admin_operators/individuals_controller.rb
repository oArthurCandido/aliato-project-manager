module AdminOperators
  class IndividualsController < ApplicationController
    before_action :authenticate_user!
    before_action :set_individual, only: [ :edit, :update, :destroy ]

    def index
      if params[:query].present?
        @individuals = Individual.where("name ILIKE ?", "%#{params[:query]}%")
                                .or(Individual.where("document_number ILIKE ?", "%#{params[:query]}%"))
      else
        @individuals = Individual.all.includes(:projects)
      end
    end

    def new
      @individual = Individual.new
    end

    def create
      @individual = Individual.new(individual_params)

      if @individual.save
        redirect_to admin_operators_individuals_path, flash: { success: "Cliente criado com sucesso." }
      else
        respond_to do |format|
          format.turbo_stream do
            render turbo_stream: [
              turbo_stream.replace("errors", partial: "layouts/errors", locals: { resource: @individual })
            ]
          end
          format.html { render :new }
        end
      end
    end

    def edit
    end

    def update
      if @individual.update(individual_params)
        redirect_to admin_operators_individuals_path, flash: { success: "Cliente atualizado com sucesso." }
      else
        respond_to do |format|
          format.turbo_stream do
            render turbo_stream: [
              turbo_stream.replace("errors", partial: "layouts/errors", locals: { resource: @individual })
            ]
          end
          format.html { render :edit }
        end
      end
    end

    def destroy
      if @individual.destroy
        redirect_to admin_operators_individuals_path, flash: { success:  "Cliente deletado com sucesso." }
      else
        redirect_to admin_operators_individuals_path, flash: { danger: "N\u00E3o \u00E9 poss\u00EDvel deletar Cliente" }
      end
    end

    private

    def set_individual
      @individual = Individual.find(params[:id])
    end

    def individual_params
      params.require(:individual).permit(:name, :document_number, :rg, :email, :phone, :zip_code, :address, :neighborhood, :city, :state, :complement)
    end
  end
end
