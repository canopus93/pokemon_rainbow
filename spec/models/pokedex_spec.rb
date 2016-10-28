require 'rails_helper'

RSpec.describe Pokedex, type: :model do
  it "should be true when save new pokedex" do
  	new_pokedex = Pokedex.new(
  		name: 'new pokedex',
  		base_health_point: 22,
  		base_attack: 22,
  		base_defence: 22,
  		base_speed: 22,
  		element_type: 'normal',
  		image_url: 'https://img.pokemondb.net/artwork/jirachi.jpg'
  	)

  	expect(new_pokedex.save).to eq(true)
  end

  describe "Default validation :" do

	  it "should be false when name is blank" do
	  	new_pokedex = Pokedex.new(
	  		base_health_point: 22,
	  		base_attack: 22,
	  		base_defence: 22,
	  		base_speed: 22,
	  		element_type: 'normal',
	  		image_url: 'https://img.pokemondb.net/artwork/jirachi.jpg'
	  	)
	  	new_pokedex.save

	  	expect(new_pokedex.save).to eq(false)
	  end

	  it "should be false when name is not unique" do
	  	first_pokedex = Pokedex.new(
	  		name: 'new pokedex',
	  		base_health_point: 22,
	  		base_attack: 22,
	  		base_defence: 22,
	  		base_speed: 22,
	  		element_type: 'normal',
	  		image_url: 'https://img.pokemondb.net/artwork/jirachi.jpg'
	  	)
	  	first_pokedex.save!

	  	new_pokedex = Pokedex.new(
	  		name: 'new pokedex',
	  		base_health_point: 22,
	  		base_attack: 22,
	  		base_defence: 22,
	  		base_speed: 22,
	  		element_type: 'normal',
	  		image_url: 'https://img.pokemondb.net/artwork/jirachi.jpg'
	  	)
	  	new_pokedex.save

	  	expect(new_pokedex.save).to eq(false)
	  end

	  it "should be false when name length > 45" do
	  	new_pokedex = Pokedex.new(
	  		name: 'rspec test name length greater than 45 char scenario',
	  		base_health_point: 22,
	  		base_attack: 22,
	  		base_defence: 22,
	  		base_speed: 22,
	  		element_type: 'normal',
	  		image_url: 'https://img.pokemondb.net/artwork/jirachi.jpg'
	  	)
	  	new_pokedex.save

	  	expect(new_pokedex.save).to eq(false)
	  end

	  it "should be false when base_health_point is blank" do
	  	new_pokedex = Pokedex.new(
	  		name: 'new pokedex',
	  		base_attack: 22,
	  		base_defence: 22,
	  		base_speed: 22,
	  		element_type: 'normal',
	  		image_url: 'https://img.pokemondb.net/artwork/jirachi.jpg'
	  	)
	  	new_pokedex.save

	  	expect(new_pokedex.save).to eq(false)
	  end

	  it "should be false when base_health_point is not number" do
	  	new_pokedex = Pokedex.new(
	  		name: 'new pokedex',
	  		base_health_point: 'a',
	  		base_attack: 22,
	  		base_defence: 22,
	  		base_speed: 22,
	  		element_type: 'normal',
	  		image_url: 'https://img.pokemondb.net/artwork/jirachi.jpg'
	  	)
	  	new_pokedex.save

	  	expect(new_pokedex.save).to eq(false)
	  end

	  it "should be false when base_health_point < 0" do
	  	new_pokedex = Pokedex.new(
	  		name: 'new pokedex',
	  		base_health_point: 0,
	  		base_attack: 22,
	  		base_defence: 22,
	  		base_speed: 22,
	  		element_type: 'normal',
	  		image_url: 'https://img.pokemondb.net/artwork/jirachi.jpg'
	  	)
	  	new_pokedex.save

	  	expect(new_pokedex.save).to eq(false)
	  end

	  it "should be false when base_attack is blank" do
	  	new_pokedex = Pokedex.new(
	  		name: 'new pokedex',
	  		base_health_point: 22,
	  		base_defence: 22,
	  		base_speed: 22,
	  		element_type: 'normal',
	  		image_url: 'https://img.pokemondb.net/artwork/jirachi.jpg'
	  	)
	  	new_pokedex.save

	  	expect(new_pokedex.save).to eq(false)
	  end

	  it "should be false when base_attack is not number" do
	  	new_pokedex = Pokedex.new(
	  		name: 'new pokedex',
	  		base_health_point: 22,
	  		base_attack: 'a',
	  		base_defence: 22,
	  		base_speed: 22,
	  		element_type: 'normal',
	  		image_url: 'https://img.pokemondb.net/artwork/jirachi.jpg'
	  	)
	  	new_pokedex.save

	  	expect(new_pokedex.save).to eq(false)
	  end

	  it "should be false when base_attack < 0" do
	  	new_pokedex = Pokedex.new(
	  		name: 'new pokedex',
	  		base_health_point: 22,
	  		base_attack: 0,
	  		base_defence: 22,
	  		base_speed: 22,
	  		element_type: 'normal',
	  		image_url: 'https://img.pokemondb.net/artwork/jirachi.jpg'
	  	)
	  	new_pokedex.save

	  	expect(new_pokedex.save).to eq(false)
	  end

	  it "should be false when base_defence is blank" do
	  	new_pokedex = Pokedex.new(
	  		name: 'new pokedex',
	  		base_health_point: 22,
	  		base_attack: 22,
	  		base_speed: 22,
	  		element_type: 'normal',
	  		image_url: 'https://img.pokemondb.net/artwork/jirachi.jpg'
	  	)
	  	new_pokedex.save

	  	expect(new_pokedex.save).to eq(false)
	  end

	  it "should be false when base_defence is not number" do
	  	new_pokedex = Pokedex.new(
	  		name: 'new pokedex',
	  		base_health_point: 22,
	  		base_attack: 22,
	  		base_defence: 'a',
	  		base_speed: 22,
	  		element_type: 'normal',
	  		image_url: 'https://img.pokemondb.net/artwork/jirachi.jpg'
	  	)
	  	new_pokedex.save

	  	expect(new_pokedex.save).to eq(false)
	  end

	  it "should be false when base_defence < 0" do
	  	new_pokedex = Pokedex.new(
	  		name: 'new pokedex',
	  		base_health_point: 22,
	  		base_attack: 22,
	  		base_defence: 0,
	  		base_speed: 22,
	  		element_type: 'normal',
	  		image_url: 'https://img.pokemondb.net/artwork/jirachi.jpg'
	  	)
	  	new_pokedex.save

	  	expect(new_pokedex.save).to eq(false)
	  end

	  it "should be false when base_speed is blank" do
	  	new_pokedex = Pokedex.new(
	  		name: 'new pokedex',
	  		base_health_point: 22,
	  		base_attack: 22,
	  		base_defence: 22,
	  		element_type: 'normal',
	  		image_url: 'https://img.pokemondb.net/artwork/jirachi.jpg'
	  	)
	  	new_pokedex.save

	  	expect(new_pokedex.save).to eq(false)
	  end

	  it "should be false when base_speed is not number" do
	  	new_pokedex = Pokedex.new(
	  		name: 'new pokedex',
	  		base_health_point: 22,
	  		base_attack: 22,
	  		base_defence: 22,
	  		base_speed: 'a',
	  		element_type: 'normal',
	  		image_url: 'https://img.pokemondb.net/artwork/jirachi.jpg'
	  	)
	  	new_pokedex.save

	  	expect(new_pokedex.save).to eq(false)
	  end

	  it "should be false when base_speed < 0" do
	  	new_pokedex = Pokedex.new(
	  		name: 'new pokedex',
	  		base_health_point: 22,
	  		base_attack: 22,
	  		base_defence: 22,
	  		base_speed: 0,
	  		element_type: 'normal',
	  		image_url: 'https://img.pokemondb.net/artwork/jirachi.jpg'
	  	)
	  	new_pokedex.save

	  	expect(new_pokedex.save).to eq(false)
	  end

	  it "should be false when element_type is blank" do
	  	new_pokedex = Pokedex.new(
	  		name: 'new pokedex',
	  		base_health_point: 22,
	  		base_attack: 22,
	  		base_defence: 22,
	  		base_speed: 22,
	  		image_url: 'https://img.pokemondb.net/artwork/jirachi.jpg'
	  	)
	  	new_pokedex.save

	  	expect(new_pokedex.save).to eq(false)
	  end

	  it "should be false when element_type length > 45" do
	  	new_pokedex = Pokedex.new(
	  		name: 'new pokedex',
	  		base_health_point: 22,
	  		base_attack: 22,
	  		base_defence: 22,
	  		base_speed: 22,
	  		element_type: 'rspec test element_type length greater than 45 char scenario',
	  		image_url: 'https://img.pokemondb.net/artwork/jirachi.jpg'
	  	)
	  	new_pokedex.save

	  	expect(new_pokedex.save).to eq(false)
	  end

	  it "should be false when element_type is not in list" do
	  	new_pokedex = Pokedex.new(
	  		name: 'new pokedex',
	  		base_health_point: 22,
	  		base_attack: 22,
	  		base_defence: 22,
	  		base_speed: 22,
	  		element_type: 'not_in_list',
	  		image_url: 'https://img.pokemondb.net/artwork/jirachi.jpg'
	  	)
	  	new_pokedex.save

	  	expect(new_pokedex.save).to eq(false)
	  end
	end
end
