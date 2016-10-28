require 'rails_helper'

RSpec.describe Skill, type: :model do
  it "should be true when save new skill" do
  	new_skill = Skill.new(
  		name: 'new skill',
  		power: 22,
  		max_pp: 22,
  		element_type: 'normal'
  	)

  	expect(new_skill.save).to eq(true)
  end

  describe "Default validation :" do
    it "should be false when name is blank" do
    	new_skill = Skill.new(
    		power: 22,
    		max_pp: 22,
    		element_type: 'normal'
    	)

    	expect(new_skill.save).to eq(false)
    end

    it "should be false when name is not unique" do
      first_skill = Skill.new(
        name: 'new skill',
        power: 22,
        max_pp: 22,
        element_type: 'normal'
      )
      first_skill.save!

    	new_skill = Skill.new(
    		name: 'new skill',
    		power: 22,
    		max_pp: 22,
    		element_type: 'normal'
    	)

    	expect(new_skill.save).to eq(false)
    end

    it "should be false when name length > 45" do
    	new_skill = Skill.new(
        name: 'rspec test name length greater than 45 char scenario',
    		power: 22,
    		max_pp: 22,
    		element_type: 'normal'
    	)

    	expect(new_skill.save).to eq(false)
    end

    it "should be false when power is blank" do
      new_skill = Skill.new(
        name: 'new skill',
        max_pp: 22,
        element_type: 'normal'
      )

      expect(new_skill.save).to eq(false)
    end

    it "should be false when power is not number" do
      new_skill = Skill.new(
        name: 'new skill',
        power: 'a',
        max_pp: 22,
        element_type: 'normal'
      )

      expect(new_skill.save).to eq(false)
    end

    it "should be false when power < 0" do
      new_skill = Skill.new(
        name: 'new skill',
        power: 0,
        max_pp: 22,
        element_type: 'normal'
      )

      expect(new_skill.save).to eq(false)
    end

    it "should be false when max_pp is blank" do
      new_skill = Skill.new(
        name: 'new skill',
        power: 22,
        element_type: 'normal'
      )

      expect(new_skill.save).to eq(false)
    end

    it "should be false when max_pp is not number" do
      new_skill = Skill.new(
        name: 'new skill',
        power: 22,
        max_pp: 'a',
        element_type: 'normal'
      )

      expect(new_skill.save).to eq(false)
    end

    it "should be false when max_pp < 0" do
      new_skill = Skill.new(
        name: 'new skill',
        power: 22,
        max_pp: 0,
        element_type: 'normal'
      )

      expect(new_skill.save).to eq(false)
    end

    it "should be false when element_type is blank" do
      new_skill = Skill.new(
        name: 'new skill',
        power: 22,
        max_pp: 22
      )

      expect(new_skill.save).to eq(false)
    end

    it "should be false when element_type length > 45" do
      new_skill = Skill.new(
        name: 'new skill',
        power: 22,
        max_pp: 22,
        element_type: 'rspec test element_type length greater than 45 char_scenario'
      )

      expect(new_skill.save).to eq(false)
    end

    it "should be false when element_type is not in list" do
      new_skill = Skill.new(
        name: 'new skill',
        power: 22,
        max_pp: 22,
        element_type: 'not_in_list'
      )

      expect(new_skill.save).to eq(false)
    end
  end
end
