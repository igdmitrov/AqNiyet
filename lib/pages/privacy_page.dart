import 'package:aqniyet/widgets/clause_subheader.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../utils/constants.dart';
import '../widgets/back_button.dart';
import '../widgets/clause.dart';
import '../widgets/clause_header.dart';
import '../widgets/footer.dart';

class PrivacyPage extends StatelessWidget {
  static String routeName = '/privacy';
  const PrivacyPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
        children: [
          Column(
            children: const [
              BackToPageButton(),
              Text(
                appName,
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.indigo,
                ),
                textAlign: TextAlign.center,
              ),
              ClauseHeader(
                header: 'Политика конфиденциальности',
              ),
              Clause(
                  clause:
                      'Политика конфиденциальности определяет принципы сбора, использования и передачи другим лицам ваших персональных данных.'),
              Clause(
                  clause:
                      'Мы придаем большое значение основополагающим правам на защиту частной жизни и считаем, что эти права должны быть одинаковыми во всем мире. Именно поэтому мы рассматриваем как персональные любые данные, которые связаны или могут быть связаны через AqNiyet с лицом, чья личность установлена или может быть установлена, независимо от того, где такое лицо проживает. Это означает, что персональными являются как данные, идентифицирующие вас напрямую, например ваше имя, так и данные, которые не идентифицируют вас напрямую, но которых может быть достаточно для установления вашей личности, например серийный номер вашего устройства. Сводные данные в рамках этой Политики конфиденциальности не считаются персональными данными.'),
              ClauseSubHeader(header: 'ОБЛАСТЬ ПРИМЕНЕНИЯ и СОГЛАСИЕ'),
              Clause(
                  clause:
                      'Используя Сайт и/или Мобильное приложение и/или иные связанные сервисы и инструменты, Пользователь предоставляет своё согласие Компании на обработку своих данных, часть которых является персональными данными, таких как имя пользователя; регион проживания, адрес электронной почты, контактный телефон, другая контактная информация и по желанию пользователя; ip-адреса, другие коммуникационные данные пользователей; сообщения, письма, заявления, передаваемые Пользователю другими Пользователями и наоборот.'),
              Clause(
                  clause:
                      'Используя Сайт и/или Мобильное приложение и/или иные связанные сервисы и инструменты, Пользователь также даёт своё согласие на передачу своих персональных данных третьим лицам, в том числе на передачу персональных данных за границу, в любую третью страну в соответствии с данной Политикой конфиденциальности.'),
              ClauseSubHeader(header: 'ИНФОРМАЦИЯ'),
              Clause(
                  clause:
                      'Информация об учетной записи: при создании Пользователем учетной записи, Компания может потребовать определенную информацию, такую как адрес электронной почты или номер сотового телефона и пароль. Учетная запись включает в себя такую информацию о Пользователях, как географическое расположение, сопутствующую информацию, в том числе фотографии, которые они могут загружать в свою учетную запись, сообщения, письма, заявления, передаваемые Пользователем другим Пользователям.'),
              Clause(
                  clause:
                      'Пользователи несут ответственность за всю информацию, размещаемую ими. Пользователь должен внимательно рассмотреть все риски, связанные с тем, что он делает определённую информацию – в частности, адрес или информацию о месте своего расположения – общедоступной.'),
              Clause(
                  clause:
                      'В рамках операций Компания может собирать личную информацию, такую как имя и контактная информация, когда Пользователи участвуют в маркетинговых акциях. В рамках деятельности Компания может также обрабатывать информацию, связанную с эффективностью рекламных кампаний, в том числе, какие объявления были просмотрены.'),
              Clause(
                  clause:
                      'Обслуживание клиентов: При обращении Пользователей в отдел обслуживания клиентов, Компания может - собирать иную личную информацию, необходимую для выполнения запроса Пользователя и получения обратной связи при необходимости. Объем информации, которая предоставляется при обращении Пользователя, контролируется самим Пользователем. Пользователь может предоставить любую информацию по своему усмотрению, если Пользователь считает, что эта информация необходима для ответа на его запрос. Компания может также связаться с Пользователем, используя существующую контактную информацию учётной записи, предоставленную для этой цели. Компания может также собирать другую информацию об общении с Пользователями, например, любые запросы в службу поддержки, подаваемые Пользователями, или любую обратную связь, предоставляемую Пользователями. Мы можем обрабатывать отзывы в качестве данных, касающихся Пользователя-автора отзыва, и Пользователя, в отношении которого был оставлен отзыв.'),
              ClauseSubHeader(header: 'ОБМЕН ИНФОРМАЦИЕЙ'),
              Clause(
                  clause:
                      'Компания может делиться информацией, которую она собирает, с аффилированными лицами (компании, действующие на основе общей собственности или под общим контролем), расположенной в какой-либо третьей стране.'),
              Clause(
                  clause:
                      'Компания не предоставляет личную информацию Пользователей не аффилированным лицам, за исключением случаев, когда на то есть соответствующее разрешение Пользователей.'),
              Clause(
                  clause:
                      'Компания может предоставлять персональные данные Пользователей на запросы компетентных органов только в случае, если такое требование соответствует законодательству Республики Казахстан и оформлено  в соответствии с требованиями законодательства Республики Казахстан.'),
              Clause(
                  clause:
                      'В соответствии с Политикой конфиденциальности, Компания обязуется не передавать в аренду или продавать любые персональные данные Пользователя. В случае если бизнес Компании или часть этого бизнеса будут проданы или реорганизованы, и Компания передает все, или практически все свои активы новому владельцу, то персональные данные пользователей могут быть переданы покупателю, чтобы обеспечить непрерывность обслуживания.'),
              Clause(
                  clause:
                      'Компания может передавать определенную обезличенную информацию (данные, которые не позволяют идентифицировать каждого индивидуального Пользователя) сторонним поставщикам услуг, доверенным партнерам или авторизованным исследователям в целях лучшего понимания, какая реклама или услуги могут заинтересовать Пользователей, улучшения общего качества и эффективности услуг или сервиса, или для обеспечения своего вклада в научные исследования, которые, по мнению Компании, могут приносить большие социальные блага.'),
              ClauseSubHeader(header: 'ПОЛЬЗОВАТЕЛЬСКИЙ КОНТРОЛЬ'),
              Clause(
                  clause:
                      'Доступ, Исправление и Удаление: Пользователи, которые создали учётную запись, или разместили объявления, могут получать доступ, исправлять или удалять информацию, которую они предоставляют. Пользователь несет ответственность за точность предоставляемых данных.'),
              Clause(
                  clause:
                      'Знать о наличии у Компании, а также третьего лица своих персональных данных, а также получать информацию, содержащую: подтверждение факта, цели, источников, способов сбора и обработки персональных данных; перечень персональных данных; сроки обработки персональных данных, в том числе сроки их хранения (право на получение информации).'),
              Clause(
                  clause:
                      'Требовать от Компании изменения и дополнения своих персональных данных при наличии оснований, подтвержденных соответствующими документами (право на исправление).'),
              Clause(
                  clause:
                      'Требовать от Компании, а также третьего лица блокирования своих персональных данных в случае наличия информации о нарушении условий сбора, обработки персональных данных (право на блокирование).'),
              Clause(
                  clause:
                      'Требовать от Компании, а также третьего лица уничтожения своих персональных данных, сбор и обработка которых произведены с нарушением законодательства Республики Казахстан, а также в иных случаях, установленных нормативными правовыми актами Республики Казахстан (право на уничтожение).'),
              Clause(
                  clause:
                      'Отозвать согласие на сбор, обработку персональных данных, кроме случаев, предусмотренных пунктом 2 статьи 8 Закона Республики Казахстан «О персональных данных и их защите» (право на отзыв согласия).'),
              Clause(
                  clause:
                      'На осуществление иных прав, предусмотренных настоящим законами Республики Казахстан.'),
              ClauseSubHeader(header: 'БЕЗОПАСНОСТЬ'),
              Clause(
                  clause:
                      'Вся информация, которую мы собираем в разумных пределах защищена техническими средствами и процедурами обеспечения безопасности в целях предотвращения несанкционированного доступа или использования данных. Аффилированные с Компанией лица, надёжные партнеры и сторонние поставщики услуг обязуются использовать полученную от Компании информацию в соответствии с нашими требованиями к безопасности и этой Политикой конфиденциальности.'),
              ClauseSubHeader(header: 'ВНЕСЕНИЕ ИЗМЕНЕНИЙ'),
              Clause(
                  clause:
                      'Компания может обновлять эту политику конфиденциальности время от времени, новая редакция Политики конфиденциальности вступает в силу с момента ее размещения.'),
              Clause(
                  clause:
                      'В случае если Компанией были внесены любые изменения в Политику Конфиденциальности, с которыми Пользователь не согласен, он обязан прекратить использование сервисов. Факт не прекращения использования является подтверждением согласия и принятия Пользователем действующей редакции Политики конфиденциальности, а также иных документов Компании.'),
              BackToPageButton(),
              Footer(),
            ],
          ),
        ],
      ),
    );
  }
}
