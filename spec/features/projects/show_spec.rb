require 'rails_helper'

RSpec.describe 'Projects Show Page' do
  before :each do
    @recycled_material_challenge = Challenge.create(theme: "Recycled Material", project_budget: 1000)
    @furniture_challenge = Challenge.create(theme: "Apartment Furnishings", project_budget: 1000)

    @news_chic = @recycled_material_challenge.projects.create(name: "News Chic", material: "Newspaper")
    @boardfit = @recycled_material_challenge.projects.create(name: "Boardfit", material: "Cardboard Boxes")

    @upholstery_tux = @furniture_challenge.projects.create(name: "Upholstery Tuxedo", material: "Couch")
    @lit_fit = @furniture_challenge.projects.create(name: "Litfit", material: "Lamp")

    @jay = Contestant.create(name: "Jay McCarroll", age: 40, hometown: "LA", years_of_experience: 13)
    @gretchen = Contestant.create(name: "Gretchen Jones", age: 36, hometown: "NYC", years_of_experience: 12)
    @kentaro = Contestant.create(name: "Kentaro Kameyama", age: 30, hometown: "Boston", years_of_experience: 8)
    @erin = Contestant.create(name: "Erin Robertson", age: 44, hometown: "Denver", years_of_experience: 15)


    ContestantProject.create(contestant_id: @jay.id, project_id: @news_chic.id)
    ContestantProject.create(contestant_id: @gretchen.id, project_id: @news_chic.id)
    ContestantProject.create(contestant_id: @gretchen.id, project_id: @upholstery_tux.id)
    ContestantProject.create(contestant_id: @kentaro.id, project_id: @upholstery_tux.id)
    ContestantProject.create(contestant_id: @kentaro.id, project_id: @boardfit.id)
    ContestantProject.create(contestant_id: @erin.id, project_id: @boardfit.id)
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

      it 'I see a count of the number of contestants on the project' do
        visit "/projects/#{@news_chic.id}"

        expect(page).to have_content("Number of Contestants: 2")
      end

      it 'I see the average years of experience for the contestants that worked on that project' do
        visit "/projects/#{@news_chic.id}"

        expect(page).to have_content("Average Contestant Experience: 12.5 years")
      end

      it 'I see a form to add a contestant to this project' do
        visit "/projects/#{@news_chic.id}"

        expect(page).to have_selector("#add_contestant")
      end

      describe 'When I fill out a field with an existing contestants id and hit "Add Contestant To Project"' do
        it 'I am taken back to the projects show page' do
          visit "/projects/#{@news_chic.id}"

          fill_in :add_contestant, with: "#{@kentaro.id}"
          click_on 'Add Contestant'

          expect(current_path).to eq("/projects/#{@news_chic.id}")
        end

        it 'I see that the number of contestants has increased by 1' do
          visit "/projects/#{@news_chic.id}"

          expect(page).to have_content("Number of Contestants: 2")
          fill_in :add_contestant, with: "#{@kentaro.id}"
          click_on 'Add Contestant'

          expect(page).to have_content("Number of Contestants: 3")
        end

        describe 'And when I visit the contestants index page' do
          it 'I see that the project listed under that contestants name' do
            visit "/projects/#{@news_chic.id}"

            expect(page).to have_content("Number of Contestants: 2")
            fill_in :add_contestant, with: "#{@kentaro.id}"
            click_on 'Add Contestant'

            visit "/contestants"

            within("#contestant-#{@kentaro.id}") do
              expect(page).to have_content(@news_chic.name)
            end
          end
        end
      end
    end
  end
end
