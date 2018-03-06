namespace :data do
  desc "add existing licenses to database"
  task :rights => :environment do
    authority = Qa::LocalAuthority.where(name: 'rights').first_or_create

    [["http://creativecommons.org/licenses/by/3.0/us/","Attribution 3.0 United States"],
    ["http://creativecommons.org/licenses/by-sa/3.0/us/","Attribution-ShareAlike 3.0 United States"],
    ["http://creativecommons.org/licenses/by-nc/3.0/us/","Attribution-NonCommercial 3.0 United States"],
    ["http://creativecommons.org/licenses/by-nd/3.0/us/","Attribution-NoDerivs 3.0 United States"],
    ["http://creativecommons.org/licenses/by-nc-nd/3.0/us/","Attribution-NonCommercial-NoDerivs 3.0 United States"],
    ["http://creativecommons.org/licenses/by-nc-sa/3.0/us/","Attribution-NonCommercial-ShareAlike 3.0 United States"],
    ["http://creativecommons.org/publicdomain/mark/1.0/","Public Domain Mark 1.0"],
    ["http://creativecommons.org/publicdomain/zero/1.0/","CC0 1.0 Universal"],
    ["http://www.europeana.eu/portal/rights/rr-r.html","All rights reserved"]].each do |record|
      Qa::LocalAuthorityEntry.where(local_authority: authority,
                                     label: record[1],
                                     uri: record[0]).first_or_create
    end
  end
end
