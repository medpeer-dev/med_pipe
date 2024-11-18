# frozen_string_literal: true

module MedPipe
  class ApplicationRecord < ActiveRecord::Base
    self.abstract_class = true

    def self.table_name_prefix
      "med_pipe_"
    end
  end
end
