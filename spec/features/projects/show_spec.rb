require 'rails_helper'

RSpec.describe 'Projects Show Page' do
  before :each do
    @recycled_material_challenge = Challenge.create(theme: "Recycled Material", project_budget: 1000)
    @furniture_challenge = Challenge.create(theme: "Apartment Furnishings", project_budget: 1000)

    @news_chic = @recycled_material_challenge.projects.create(name: "News Chic", material: "Newspaper")
    @boardfit = @recycled_material_challenge.projects.create(name: "Boardfit", material: "Cardboard Boxes")

    @upholstery_tux = @furniture_challenge.projects.create(name: "Upholstery Tuxedo", material: "Couch")
    @lit_fit = @furniture_challenge.projects.create(name: "Litfit", material: "Lamp")
  end
  describe 'As a visitor' do
    describe 'When I visit a projects show page ("/projects/:id"),' do
      it 'I see that projects name and material' do
        visit "/projects/#{@news_chic.id}"

        expect(page).to have_content(@news_chic.name)
        expect(page).to have_content(@news_chic.material)
      end

      it 'I see the theme of the challenge that this project belongs to' do
        visit "/projects/#{@news_chic.id}"

        expect(page).to have_content(@recycled_material_challenge.theme)
      end
    end
  end
end
