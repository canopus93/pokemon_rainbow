class SkillsDecorator
	include Rails.application.routes.url_helpers
	include ActionView::Helpers::UrlHelper

	SkillsDecoratorResult = Struct.new(
		:id,
		:name,
		:power,
		:max_pp,
		:element_type,
		:link_to_show,
		:link_to_edit,
		:link_to_delete
	)

	def initialize(context)
		@context = context
	end

	def decorate_for_index(skills)
		results = []

		skills.each do |skill|
			results << generate_decorator_result(skill: skill)
		end
		results
	end

	def decorate_for_show(skill)
		generate_decorator_result(skill: skill)
	end

	private
		def generate_decorator_result(skill:)
			result = SkillsDecoratorResult.new
			result.id = skill.id
			result.name = skill.name
			result.power = skill.power
			result.max_pp = skill.max_pp
			result.element_type = skill.element_type
			result.link_to_show = link_to_show(skill)
			result.link_to_edit = link_to_edit(skill)
			result.link_to_delete = link_to_delete(skill)
			result
		end

		def link_to_show(skill)
			@context.helpers.link_to skill.name, skill_path(skill.id)
		end

		def link_to_edit(skill)
			@context.helpers.link_to 'Edit', edit_skill_path(skill.id), class: 'btn btn-warning'
		end

		def link_to_delete(skill)
			@context.helpers.link_to 'Remove', skill_path(skill.id),
										method: :delete, 
										data: { confirm: "Are you sure to remove #{skill.name}?"}, class: 'btn btn-danger'
		end
end