module Webspicy
  class Configuration

    def initialize
      @folders = []
      yield(self) if block_given?
    end
    attr_reader :folders

    # Adds a folder to the list of folders where test case definitions are
    # to be found.
    def add_folder(folder)
      folder = Path(folder)
      raise "Folder `#{folder}` does not exists" unless folder.exists? && folder.directory?
      @folders << folder
    end

  end
end
