const { select } = require("./bd_controller");


class Querys {
  getSelectUsersDefault() {
    const users = select(`
    users.id_user,
    users.name_user,  
    users.email_user,  
    users.phone_user,  
    users.zip_code_user,  
    users.street_user,  
    users.address_complement_user,  
    users.district_user,  
    users.ART,
    users.CREA,
    cities.name_city,
    states.name_state,
    states.acronym,
    companies.name_company,
    companies.id_company is not null as is_administrator,
    case when companies.id_company is not null then (companies.id_company) else (CompanyUser.id_company) end as id_company,
    plans.name_plan,
    case when companies.id_company is not null then null else CompanyUser.id_company end as linked_company, 
    case when companies.id_company is not null then (plans.price) else null end as price,
    plans.isCompany as is_company,
    case when companies.id_company is not null then (plancompany.start_date) else null end as start_date,
    case when companies.id_company is not null then (plancompany.end_date) else null end as end_date
    `, 'users'
    )
      .leftJoin('cities', 'users.id_city = cities.id_city')
      .leftJoin('states', 'cities.id_state = states.id_state')
      .leftJoin('companies', 'users.id_user = companies.id_company')
      .leftJoin('plancompany', 'companies.id_company = PlanCompany.id_company')
      .leftJoin('plans', 'plans.id_plan = plancompany.id_plan')
      .leftJoin('companyuser', 'companyuser.id_user = users.id_user')
    return users;
  }



  async checkAndGetUserAdministrator(id_administrator) {
    const userAdministrator = await this.getSelectUsersDefault()
      .where(`users.id_user = '${id_administrator}'`)
      .execute();
    if (userAdministrator.length != 0) {
      const isAdministrator = userAdministrator[0].is_administrator;
      if (isAdministrator) {
        return userAdministrator[0];
      }
    }
    throw Error('Somente o administrador pode ter acesso a dados de colaboradores');
  }
}
module.exports = Querys;