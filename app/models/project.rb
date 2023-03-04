class Project < ActiveRecord::Base
    belongs_to :project
    has_many :projects_tags
    has_many :tags, through: :projects_tags
end