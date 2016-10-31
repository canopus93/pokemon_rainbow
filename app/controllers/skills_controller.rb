class SkillsController < ApplicationController

	add_breadcrumb "Skills", :skills_path

	def index
		decorator = SkillsDecorator.new(self)
		@decorated_skills = decorator.decorate_for_index(Skill.paginate(page: params[:page], per_page: 10).order(id: :ASC))
		@pagination_skills = Skill.paginate(page: params[:page], per_page: 10).order(id: :ASC)
	end

	def show
		decorator = SkillsDecorator.new(self)
		@decorated_skill = decorator.decorate_for_show(Skill.find(params[:id]))
		add_breadcrumb @decorated_skill.name
	end

	def new
		@skill = Skill.new
		add_breadcrumb 'New'
	end

	def edit
		@skill = Skill.find(params[:id])
		add_breadcrumb @skill.name, @skill
		add_breadcrumb 'Edit'
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
