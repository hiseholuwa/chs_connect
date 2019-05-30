import 'package:chs_connect/models/chs_account.dart';
import 'package:meta/meta.dart';
import 'package:rebloc/rebloc.dart';

class ChsInitAccountAction extends Action {
  const ChsInitAccountAction();
}

class ChsOnDataAccountAction extends Action {
  final ChsAccountModel payload;
  const ChsOnDataAccountAction({
    @required this.payload,
  });
}

class ChsOnReadNotice extends Action {
  final ChsAccountModel payload;
  const ChsOnReadNotice({
    @required this.payload,
  });
}