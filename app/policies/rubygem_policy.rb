class RubygemPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if rubygems_org_admin?
        scope.all
      else
        scope.with_versions
      end
    end
  end

  def avo_index?
    rubygems_org_admin?
  end

  def avo_show?
    rubygems_org_admin?
  end

  has_association :versions
  has_association :latest_version
  has_association :ownerships
  has_association :ownerships_including_unconfirmed
  has_association :ownership_calls
  has_association :ownership_requests
  has_association :subscriptions
  has_association :subscribers
  has_association :web_hooks
  has_association :linkset
  has_association :gem_download
  has_association :audits
end
