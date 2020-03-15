import 'package:fritter_for_reddit/models/subreddits/children.dart';

class SubredditsSubscribed {
  final String kind;
  final Children data;

  SubredditsSubscribed.fromJsonMap(Map<String, dynamic> map)
      : kind = map["kind"],
        data = Children.fromList(map["data"]["children"]);

//	Map<String, dynamic> toJson() {
//		final Map<String, dynamic> data = new Map<String, dynamic>();
//		data['kind'] = kind;
//		data['data'] = data == null ? null : data.toJson();
//		return data;
//	}
}
