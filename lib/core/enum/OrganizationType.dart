
enum OrganizationType{
  def,
  office,
  education,
  retail;

  String get getTitle{
    switch(this){
      case OrganizationType.office:
        return "Office";
      case OrganizationType.education:
        return "Education";
      case OrganizationType.retail:
        return "Retail";
      case OrganizationType.def:
        return "Select Organization";
    }
  }

}