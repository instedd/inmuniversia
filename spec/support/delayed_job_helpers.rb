module DelayedJobHelpers

  def run_jobs
    successes, failures = Delayed::Worker.new.work_off
  end

end