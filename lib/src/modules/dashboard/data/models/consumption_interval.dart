class ConsumptionInterval {
  const ConsumptionInterval(this.day, this.averageUsage);

  final double day;
  final double averageUsage;

  factory ConsumptionInterval.fromJson(Map<String, dynamic> json) =>
      ConsumptionInterval(
        json["day"],
        json["averageUsage"],
      );

  Map<String, dynamic> toJson() => {"day": day, "averageUsage": averageUsage};
}

/*
token : eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjY3ZGEyNTAzZTRmZTJlMWYzYmRkMTYwYSIsImVtYWlsIjoibWFobW91ZC5hdGVmMzE2N0BnbWFpbC5jb20iLCJyb2xlIjoidXNlciIsImlhdCI6MTc0NTUyNjkwNSwiZXhwIjoxNzQ4MTE4OTA1fQ.YcEOe-v_LqcTFYrcdAQlBNBffCW6dIcQwfxBIQymclk
id:67da2503e4fe2e1f3bdd160a

admin data

{

{
    "email":"ahmedmohammedsalah200@gmail.com",
    "password":"12345678"
},

    "message": "Login successful!",
    "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjY4MGE5YjJkY2RmNzU2YjBlMDkwOWRkZSIsImVtYWlsIjoiYWhtZWRtb2hhbW1lZHNhbGFoMjAwQGdtYWlsLmNvbSIsInJvbGUiOiJhZG1pbiIsImlhdCI6MTc0NTUyNjk4MywiZXhwIjoxNzQ4MTE4OTgzfQ.dKpQ3GPymi3Ex3AMjTY7xZxjUI0QHQHEhCbUYHuy6Gk",
    "data": {
        "id": "680a9b2dcdf756b0e0909dde",
        "username": "AhmedSalah24",
        "email": "ahmedmohammedsalah200@gmail.com",
        "role": "admin"
    }
}
 */
