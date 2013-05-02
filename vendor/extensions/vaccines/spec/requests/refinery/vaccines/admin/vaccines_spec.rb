# encoding: utf-8
require "spec_helper"

describe Refinery do
  describe "Vaccines" do
    describe "Admin" do
      describe "vaccines" do
        login_refinery_user

        describe "vaccines list" do
          before do
            FactoryGirl.create(:vaccine, :name => "UniqueTitleOne")
            FactoryGirl.create(:vaccine, :name => "UniqueTitleTwo")
          end

          it "shows two items" do
            visit refinery.vaccines_admin_vaccines_path
            page.should have_content("UniqueTitleOne")
            page.should have_content("UniqueTitleTwo")
          end
        end

        describe "create" do
          before do
            visit refinery.vaccines_admin_vaccines_path

            click_link "Add New Vaccine"
          end

          context "valid data" do
            it "should succeed" do
              fill_in "Name", :with => "This is a test of the first string field"
              click_button "Save"

              page.should have_content("'This is a test of the first string field' was successfully added.")
              Refinery::Vaccines::Vaccine.count.should == 1
            end
          end

          context "invalid data" do
            it "should fail" do
              click_button "Save"

              page.should have_content("Name can't be blank")
              Refinery::Vaccines::Vaccine.count.should == 0
            end
          end

          context "duplicate" do
            before { FactoryGirl.create(:vaccine, :name => "UniqueTitle") }

            it "should fail" do
              visit refinery.vaccines_admin_vaccines_path

              click_link "Add New Vaccine"

              fill_in "Name", :with => "UniqueTitle"
              click_button "Save"

              page.should have_content("There were problems")
              Refinery::Vaccines::Vaccine.count.should == 1
            end
          end

        end

        describe "edit" do
          before { FactoryGirl.create(:vaccine, :name => "A name") }

          it "should succeed" do
            visit refinery.vaccines_admin_vaccines_path

            within ".actions" do
              click_link "Edit this vaccine"
            end

            fill_in "Name", :with => "A different name"
            click_button "Save"

            page.should have_content("'A different name' was successfully updated.")
            page.should have_no_content("A name")
          end
        end

        describe "destroy" do
          before { FactoryGirl.create(:vaccine, :name => "UniqueTitleOne") }

          it "should succeed" do
            visit refinery.vaccines_admin_vaccines_path

            click_link "Remove this vaccine forever"

            page.should have_content("'UniqueTitleOne' was successfully removed.")
            Refinery::Vaccines::Vaccine.count.should == 0
          end
        end

      end
    end
  end
end
