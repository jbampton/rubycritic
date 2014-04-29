require "rubycritic/source_locator"
require "rubycritic/analysers_runner"
require "rubycritic/smells_aggregator"
require "rubycritic/source_control_systems/source_control_system"
require "rubycritic/revision_comparator"
require "rubycritic/report_generators/reporter"

module Rubycritic

  class Rubycritic
    def initialize
      @source_control_system = SourceControlSystem.create
    end

    def critique(paths)
      source = SourceLocator.new(paths)
      smell_adapters = AnalysersRunner.new(source.paths).run
      smells = SmellsAggregator.new(smell_adapters).smells
      if @source_control_system.has_revision?
        smells = RevisionComparator.new(smells, @source_control_system).smells
      end
      Reporter.new(source.pathnames, smells).generate_report
    end
  end

end
