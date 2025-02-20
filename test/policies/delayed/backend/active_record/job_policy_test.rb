require "test_helper"

class Delayed::Backend::ActiveRecord::JobPolicyTest < ActiveSupport::TestCase
  setup do
    Fastly.delay.purge
    @delayed_job = Delayed::Job.sole
    @admin = FactoryBot.create(:admin_github_user, :is_admin)
    @non_admin = FactoryBot.create(:admin_github_user)
  end

  def test_scope
    assert_equal [@delayed_job], Pundit.policy_scope!(
      @admin,
      Delayed::Job
    ).to_a
  end

  def test_avo_index
    refute_predicate Pundit.policy!(@admin, ApiKey), :avo_index?
    refute_predicate Pundit.policy!(@non_admin, ApiKey), :avo_index?
  end

  def test_avo_show
    assert_predicate Pundit.policy!(@admin, @delayed_job), :avo_show?
    refute_predicate Pundit.policy!(@non_admin, @delayed_job), :avo_show?
  end

  def test_avo_create
    refute_predicate Pundit.policy!(@admin, ApiKey), :avo_create?
    refute_predicate Pundit.policy!(@non_admin, ApiKey), :avo_create?
  end

  def test_avo_update
    refute_predicate Pundit.policy!(@admin, @delayed_job), :avo_update?
    refute_predicate Pundit.policy!(@non_admin, @delayed_job), :avo_update?
  end

  def test_avo_destroy
    assert_predicate Pundit.policy!(@admin, @delayed_job), :avo_destroy?
    refute_predicate Pundit.policy!(@non_admin, @delayed_job), :avo_destroy?
  end
end
