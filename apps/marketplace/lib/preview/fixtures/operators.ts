import { OperatorProfileData } from "../../data/types";

/**
 * Dữ liệu hồ sơ nhà xe mẫu chép đúng từng chữ và số từ Figma 1443:12312.
 */
export const operatorProfileFixture: OperatorProfileData = {
  id: "opr-phuongnam",
  name: "Phương Nam Travel",
  code: "PN",
  isVerified: true,
  description:
    "Nhà xe chuyên tuyến TP. Hồ Chí Minh – Tây Nguyên với đội xe giường nằm và cabin Limousine. Phục vụ trung chuyển miễn phí giữa văn phòng và bến xe.",
  hotline: "1900 8686",
  email: "cskh@phuongnamtravel.vn",
  headquarters: "TP. Hồ Chí Minh",
  metrics: {
    ratingAverageText: "4,6 / 5",
    ratingTotalText: "8.930 đánh giá hợp lệ",
    cancellationRateText: "0,8%",
    cancellationRatePeriod: "90 ngày gần nhất",
    refundDisputeRateText: "1,2%",
    refundDisputePeriod: "90 ngày gần nhất",
    checkinRateText: "Chưa đủ dữ liệu",
    checkinRateNote: "Sẽ hiển thị khi đủ chuyến"
  },
  featuredRoutes: [
    {
      id: "route-sg-dl",
      routeName: "TP. Hồ Chí Minh → Đà Lạt",
      metaText: "7 giờ • Giường nằm, Cabin",
      minPriceVnd: "280000",
      imageUrl: "/images/route-sg-dalat.jpg",
      searchUrl: "/trips?origin=TP.+Hồ+Chí+Minh&destination=Đà+Lạt&operator=opr-phuongnam"
    },
    {
      id: "route-sg-nt",
      routeName: "TP. Hồ Chí Minh → Nha Trang",
      metaText: "8 giờ 30 phút • Giường nằm",
      minPriceVnd: "320000",
      imageUrl: "/images/route-sg-nhatrang.jpg",
      searchUrl: "/trips?origin=TP.+Hồ+Chí+Minh&destination=Nha+Trang&operator=opr-phuongnam"
    },
    {
      id: "route-sg-vt",
      routeName: "TP. Hồ Chí Minh → Vũng Tàu",
      metaText: "2 giờ 15 phút • Ghế ngồi",
      minPriceVnd: "120000",
      imageUrl: "/images/route-sg-vungtau.jpg",
      searchUrl: "/trips?origin=TP.+Hồ+Chí+Minh&destination=Vũng+Tàu&operator=opr-phuongnam"
    }
  ],
  reviews: [
    {
      id: "op-rev-01",
      authorName: "Trần Thu Hà",
      authorInitial: "T",
      routeAndDateText: "TP. Hồ Chí Minh → Đà Lạt • 02/10/2026",
      rating: 5.0,
      content:
        "Xe sạch, khởi hành đúng giờ. Nhân viên hỗ trợ trung chuyển từ văn phòng ra bến rất nhanh."
    },
    {
      id: "op-rev-02",
      authorName: "Lê Minh Quân",
      authorInitial: "L",
      routeAndDateText: "TP. Hồ Chí Minh → Đà Lạt • 27/09/2026",
      rating: 4.0,
      content:
        "Giường rộng, có cổng sạc. Trạm dừng nghỉ hơi đông vào cuối tuần."
    },
    {
      id: "op-rev-03",
      authorName: "Phạm Ngọc Anh",
      authorInitial: "P",
      routeAndDateText: "TP. Hồ Chí Minh → Nha Trang • 19/09/2026",
      rating: 4.5,
      content: "Tài xế chạy êm, đến sớm hơn dự kiến 15 phút."
    }
  ],
  terms: [
    "Có mặt tại điểm đón trước giờ khởi hành ít nhất 30 phút.",
    "Mỗi hành khách được mang 20 kg hành lý ký gửi và 1 túi xách tay.",
    "Trẻ em dưới 5 tuổi ngồi chung chỗ với người lớn đi kèm.",
    "Hủy / hoàn tiền theo chính sách của từng chuyến, hiển thị trước khi đặt."
  ]
};
