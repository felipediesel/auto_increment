require 'spec_helper'
require 'models/organization'
require 'models/department'
require 'models/worker'

describe AutoIncrement do
  before :all do
    @robarin_organization = Organization.create name: 'Robarin'

    @soft_dev_department = @robarin_organization.departments.create name: 'SoftDev'
    @dev_schl_department = @robarin_organization.departments.create name: 'DevSchool'

    @soft_dev_worker1 = @soft_dev_department.workers.create name: 'Igor'
    @soft_dev_worker2 = @soft_dev_department.workers.create name: 'Dima'
    @soft_dev_worker3 = @soft_dev_department.workers.create name: 'Sergey'

    @dev_schl_worker1 = @dev_schl_department.workers.create name: 'Igor'
    @dev_schl_worker2 = @dev_schl_department.workers.create name: 'Azamat'
  end

  describe 'related model' do
    # Organization <-> Departments <-> Workers
    # Test Worker code_in_department dependent on Department
    # Test Department code_in_organization dependent on Organization

    it { expect(@soft_dev_department.code_in_organization).to eq 1 }
    it { expect(@dev_schl_department.code_in_organization).to eq 2 }
    
    
    it { expect(@soft_dev_worker1.code_in_department).to eq 1 }
    it { expect(@soft_dev_worker2.code_in_department).to eq 2 }
    it { expect(@soft_dev_worker3.code_in_department).to eq 3 }
    
    it { expect(@dev_schl_worker1.code_in_department).to eq 1 }
    it { expect(@dev_schl_worker2.code_in_department).to eq 2 }
  end
  
  describe 'related through model' do
    # Organization <-> Departments <-> Workers
    # Test Worker code_in_organization dependent on Organization

    it { expect(@soft_dev_worker1.code_in_organization).to eq 1 }
    it { expect(@soft_dev_worker2.code_in_organization).to eq 2 }
    it { expect(@soft_dev_worker3.code_in_organization).to eq 3 }

    it { expect(@dev_schl_worker1.code_in_organization).to eq 4 }
    it { expect(@dev_schl_worker2.code_in_organization).to eq 5 }
  end
end

describe AutoIncrement do
  before :all do
    threads = []
    lock = Mutex.new
    organization = Organization.create name: 'Organization'

    5.times do |_t|
      threads << Thread.new do
        lock.synchronize do
          department1 = organization.departments.create name: 'Department'

          5.times do |_thr|
            department1.workers.create name: 'Worker'
          end
        end
      end
    end
    threads.each(&:join)
  end

  describe 'locks query for increment' do
    
    Organization.all.each do |organization|
      organization.departments.each_with_index do |department, department_index|
        it { expect(department.code_in_organization).to eq department_index + 1 }

        department.workers.each_with_index do |worker, worker_index|
          it { expect(worker.code_in_department).to eq worker_index + 1 }
        end
      end

      organization.workers.each_with_index do |worker, index|
        it { expect(worker.code_in_organization).to eq index + 1 }
      end
    end
  end
end
