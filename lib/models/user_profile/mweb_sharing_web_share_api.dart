
class Mweb_sharing_web_share_api {

  final String owner;
  final String variant;
  final int experiment_id;

	Mweb_sharing_web_share_api.fromJsonMap(Map<String, dynamic> map): 
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
