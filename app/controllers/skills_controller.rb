class SkillsController < ApplicationController
	def index
		decorator = SkillsDecorator.new(self)
		@decorated_skills = decorator.decorate_for_index(Skill.order(id: :ASC))
	end

	def show
		decorator = SkillsDecorator.new(self)
		@decorated_skill = decorator.decorate_for_show(Skill.find(params[:id]))
	end

	def new
		@skill = Skill.new
	end

	def edit
		@skill = Skill.find(params[:id])
	end

	def create
		@skill = Skill.new(skill_params)

		if @skill.save
			redirect_to @skill
		else
			render 'new'
		end
	end

	def update
		@skill = Skill.find(params[:id])

		if @skill.update(skill_params)
			redirect_to @skill
		else
			render 'edit'
		end
	end

	def destroy
		@skill = Skill.find(params[:id])
		@skill.destroy

		redirect_to skills_path
	end

	private
		def skill_params
			params.require(:skill).permit(:name, :power, :max_pp, :element_type)
		end 
end
