# Hướng dẫn tạo tài khoản AWS và nhận credit cho demo API

**Ngày đối chiếu tài liệu:** 29/10/2026. **Trạng thái:** hướng dẫn chuẩn bị, chưa thực hiện trên tài khoản thật.
**Phạm vi:** tạo tài khoản, kiểm tra ưu đãi, nhận credit đủ điều kiện rồi chuyển sang triển khai API.
API dự kiến chạy thường trực; worker chỉ bật trước/trong buổi demo khi cần. PostgreSQL, MongoDB, Redis và R2 giữ nguyên.

## 1. Chuẩn bị

- Email bạn kiểm soát lâu dài, điện thoại nhận SMS/cuộc gọi, thông tin liên hệ và phương thức thanh toán hợp lệ.
- Ứng dụng xác thực hoặc passkey/security key để bật MFA.
- Tự nhập mật khẩu, mã OTP/MFA và thông tin thẻ trên website AWS; không gửi các thông tin này vào chat hoặc repository.
- Mở [AWS Free Tier](https://aws.amazon.com/free/) và bắt đầu đăng ký từ liên kết của AWS.

AWS quyết định điều kiện nhận ưu đãi khi đăng ký. Không tạo tài khoản trùng để cố nhận thêm credit.

## 2. Chọn kiểu đăng ký và gói tài khoản

AWS hiện có thể hiển thị hai kiểu đăng ký:

| Kiểu đăng ký | Ý nghĩa với kế hoạch này |
| --- | --- |
| Truyền thống, tài liệu gọi là **Sign up for AWS (advanced)** | Chủ động cấu hình account, region, IAM và network; ưu tiên khi được chọn để chuẩn bị triển khai tại Singapore và kiểm tra quyền dùng Lightsail. |
| Trải nghiệm mới, **Sign up for AWS (new)** | Đăng nhập bằng Builder ID/provider, tổ chức tài nguyên theo project và có region/cấu hình sẵn; phải kiểm tra dịch vụ và region được hỗ trợ trước khi tiếp tục. |

**Kiểu đăng ký advanced khác với Paid account plan.** Chọn kiểu truyền thống không có nghĩa là phải chọn gói trả phí.
Không bấm nâng cấp account chỉ vì tên màn hình khác hướng dẫn. Nếu chỉ thấy trải nghiệm mới, ghi lại tên kiểu tài khoản và các lựa chọn region/dịch vụ để đối chiếu.
Nguồn: [So sánh cách đăng ký](https://docs.aws.amazon.com/accounts/latest/reference/sign-up-for-aws.html).

Đối với buổi thiết lập đầu tiên:

1. Chọn **Free account plan** nếu AWS cung cấp và xác nhận tài khoản đủ điều kiện.
2. Chọn **Basic support** khi màn hình hỏi gói hỗ trợ.
3. Nếu chỉ được cung cấp Paid plan, dừng ở bước chọn gói để kiểm tra điều kiện và chi phí trước khi chấp nhận.
4. Không tạo/join AWS Organizations hoặc bật Control Tower để nhận credit; việc này có thể làm mất quyền nhận thêm ưu đãi Free Tier.

Free plan kết thúc sau **6 tháng hoặc khi hết credit, tùy mốc nào đến trước**; tài khoản có thể bị đóng và mất quyền truy cập tài nguyên/dữ liệu.
Paid plan có thể tính phí vượt credit hoặc cho hạng mục không được credit chi trả. Hướng dẫn này không yêu cầu tự động nâng cấp.
Nguồn: [Chọn gói tài khoản](https://docs.aws.amazon.com/awsaccountbilling/latest/aboutv2/free-tier-plans.html), [FAQ Free Tier](https://aws.amazon.com/free/free-tier-faqs/).

## 3. Hoàn tất đăng ký

Theo [hướng dẫn đăng ký truyền thống của AWS](https://docs.aws.amazon.com/accounts/latest/reference/getting-started.html):

1. Nhập email và tên tài khoản, ví dụ `vexenhanh-demo`; xác thực email.
2. Đặt mật khẩu riêng cho root user và lưu trong trình quản lý mật khẩu.
3. Điền thông tin liên hệ chính xác theo yêu cầu màn hình.
4. Thêm phương thức thanh toán hợp lệ; đối chiếu tên gói và điều kiện trước khi tiếp tục.
5. Hoàn thành xác minh SMS/cuộc gọi nếu AWS yêu cầu.
6. Xác nhận Basic support và hoàn tất đăng ký.
7. Đợi email kích hoạt; thường vài phút, đôi khi tới 24 giờ. Sau đó đăng nhập Console.

Tên/thứ tự màn hình có thể thay đổi. Nếu nhận giao diện project/Builder ID, dùng [hướng dẫn trải nghiệm mới](https://docs.aws.amazon.com/accounts/latest/reference/sign-in-new.html) để nhận biết luồng đang sử dụng.

Sau lần đăng nhập đầu:

- Bật MFA cho root user; giữ phương án khôi phục ở nơi riêng an toàn.
- **Không tạo access key cho root user.** Quyền/credential phục vụ deploy được chuẩn bị ở bước triển khai, theo nhu cầu thực tế.
- Kiểm tra đang ở đúng account; với account truyền thống, chọn **Asia Pacific (Singapore), `ap-southeast-1`** khi tạo tài nguyên demo sau này.

Nguồn: [MFA cho root user](https://docs.aws.amazon.com/IAM/latest/UserGuide/enable-mfa-for-root.html), [Thực hành quản lý root user](https://docs.aws.amazon.com/IAM/latest/UserGuide/root-user-best-practices.html).

## 4. Xác nhận credit ban đầu trước khi tạo máy

1. Mở **Billing and Cost Management**; xem tên plan, số credit và ngày hết hạn.
2. Với giao diện truyền thống, kiểm tra trang **Credits**. Giao diện mới có thể hiển thị số credit trong AWS Settings/current plan.
3. Tài liệu AWS mô tả **$100 credit lúc đăng ký và tối đa $100 bổ sung**; lấy ưu đãi và số dư thực tế trên account làm căn cứ.
4. Chưa thấy credit hoặc không thấy điều kiện ưu đãi thì kiểm tra lại trước khi tạo tài nguyên tính phí.

Không coi **$200** là số tiền có ngay; không quy đổi thành số tháng chạy miễn phí trước khi biết mức tiêu thụ.
Nguồn: [Free Tier và hoạt động nhận credit](https://docs.aws.amazon.com/hands-on/latest/control-your-costs-free-tier-budgets/control-your-costs-free-tier-budgets.html).

## 5. Nhận credit bổ sung theo widget của tài khoản

Mở **Console Home → Explore AWS**, chọn bộ lọc **Earn AWS credits** nếu được hiển thị.
Tutorial AWS mô tả năm hoạt động, **$20 mỗi hoạt động**. Mức thưởng, điều kiện, region và hạn hoàn thành trên widget của account hiện tại mới là căn cứ thao tác.
Nguồn: [Danh sách hoạt động](https://docs.aws.amazon.com/awsaccountbilling/latest/aboutv2/free-tier-plans-activities.html), [Tutorial mức thưởng](https://docs.aws.amazon.com/hands-on/latest/control-your-costs-free-tier-budgets/control-your-costs-free-tier-budgets.html).

| Thứ tự | Hoạt động | Cách làm |
| --- | --- | --- |
| 1 | AWS Budgets | Làm trước: mở hoạt động từ widget, tạo cost budget và email cảnh báo theo hướng dẫn. Dùng budget chỉ theo dõi/cảnh báo; chưa cần actions hoặc reports. |
| 2 | Amazon EC2 | Launch instance theo widget. Có thể phối hợp với bước dựng máy API nếu yêu cầu nhiệm vụ cho phép; không mặc định Lightsail hoàn thành nhiệm vụ EC2. |
| 3 | AWS Lambda | Theo widget tạo app nhỏ với function URL, gọi thử, xác nhận hoàn thành rồi dọn tài nguyên thử. |
| 4 | Amazon Bedrock | Gửi prompt ngắn bằng model/on-demand được nhiệm vụ hỗ trợ; không tạo provisioned throughput hoặc tài nguyên ngoài nhiệm vụ. |
| 5 | Amazon RDS | Tạo DB thử nhỏ theo widget; xác nhận nhận thưởng rồi xóa. DB này không thay PostgreSQL hiện có của dự án. |

Budgets chỉ theo dõi/cảnh báo được AWS miễn phí; budget không phải công tắc tự ngắt chi tiêu.
EC2, Lambda, Bedrock và RDS có thể phát sinh phí dịch vụ trừ credit khi thực hành.
Nguồn: [Budgets pricing](https://aws.amazon.com/aws-cost-management/aws-budgets/pricing/), [Ghi chú phí của các hoạt động](https://docs.aws.amazon.com/awsaccountbilling/latest/aboutv2/free-tier-plans-activities.html).

Sau mỗi hoạt động:

1. Kiểm tra widget báo hoàn thành, rồi kiểm tra số dư/trang Credits.
2. Credit có thể mất **tới 30 phút** để xuất hiện; không tạo lại tài nguyên chỉ vì chưa thấy ngay.
3. Ghi tên nhiệm vụ, mức credit đã nhận và hạn hết hạn; không ghi ARN/credential/secret vào tài liệu công khai.
4. Theo dõi hạn riêng của nhiệm vụ; AWS mô tả cửa sổ hoàn thành trong sáu tháng đầu. Không hoãn mọi nhiệm vụ tới sát ngày hết hạn.

Nguồn: [FAQ về thời gian nhận và điều kiện credit](https://aws.amazon.com/free/free-tier-faqs/).

## 6. Dọn tài nguyên thực hành, không đụng dữ liệu dự án

Đặt tên rõ cho tài nguyên thử, ví dụ `vxn-credit-lab-*`, và kiểm tra đúng account/region/tên trước khi xóa.
Chỉ dọn tài nguyên vừa tạo để học/nhận thưởng; giữ máy API nếu đã quyết định dùng máy đó cho demo.

- **EC2 thử:** terminate instance khi xong; kiểm tra volume EBS nào không bị xóa theo instance, snapshot thử và Elastic IP còn cấp phát. Stop instance chưa dừng phí lưu trữ/IP. [EC2 termination](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/how-ec2-instance-termination-works.html), [Elastic IP](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/elastic-ip-addresses-eip.html).
- **RDS thử, không có dữ liệu cần giữ:** tắt deletion protection nếu cần, xóa DB và bỏ lựa chọn tạo final snapshot/giữ automated backups. Kiểm tra snapshot thủ công và backup thử còn lại vì có thể tiếp tục tính phí. Không áp dụng bước bỏ backup cho DB dự án. [Xóa RDS DB](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/USER_DeleteInstance.html).
- **Lambda thử:** xóa function/URL khi hoàn tất; kiểm tra log group và tài nguyên phụ đã tạo trong bài thực hành. [Quản lý function URL](https://docs.aws.amazon.com/lambda/latest/dg/urls-configuration.html).
- **Bedrock:** kết thúc thử prompt; kiểm tra không vô tình để lại tài nguyên provisioned hoặc subscription ngoài nhiệm vụ.
- **Budget cảnh báo:** giữ lại để theo dõi chi phí của máy API.

Kiểm tra Billing/chi phí sau thực hành và các region đã dùng. Số liệu billing có độ trễ; xóa tài nguyên không xóa phí đã phát sinh.

## 7. Thông tin cần có để chuyển sang deploy

Chỉ cần báo các trạng thái không chứa bí mật sau:

- Đăng ký/kích hoạt thành công chưa; kiểu truyền thống hay project/Builder ID.
- Tên plan thực tế: Free hay Paid; Basic support đã chọn chưa; MFA đã bật chưa.
- Credit đang có, ngày hết hạn và tên các nhiệm vụ đã nhận thưởng/còn xuất hiện trên widget.
- Có chọn được Singapore không; Console có mở được Lightsail hoặc EC2 theo plan hiện tại không.
- Có tài nguyên thử nào đang chạy/cần dọn không; có lỗi đăng ký hoặc điều kiện ưu đãi nào cần xử lý không.

Không cần gửi mật khẩu, OTP/MFA, thông tin thẻ, private key hoặc access key.
Khi account và credit đã xác nhận, làm tiếp [Hướng dẫn triển khai API demo lên AWS](AWS-DEPLOY-API-guide.md).
