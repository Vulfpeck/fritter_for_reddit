
class Email_verification {

  final String owner;
  final String variant;
  final int experiment_id;

	Email_verification.fromJsonMap(Map<String, dynamic> map): 
		owner = map["owner"],
		variant = map["variant"],
		experiment_id = map["experiment_id"];

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['owner'] = owner;
		data['variant'] = variant;
		data['experiment_id'] = experiment_id;
		return data;
	}
}
