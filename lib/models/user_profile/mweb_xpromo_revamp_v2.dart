
class Mweb_xpromo_revamp_v2 {

  final String owner;
  final String variant;
  final int experiment_id;

	Mweb_xpromo_revamp_v2.fromJsonMap(Map<String, dynamic> map): 
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
