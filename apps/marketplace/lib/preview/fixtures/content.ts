import type {
  ArticleCategory,
  ArticleDetail,
  ArticleSummary,
  FaqGroup,
  LegalDocumentData
} from "../../data/types";

/**
 * Danh sách chuyên mục bài viết (SCR-PSG-02 - Figma 1449:20595).
 */
export const articleCategoriesFixture: readonly ArticleCategory[] = [
  { id: "cat-all", slug: "all", name: "Tất cả", count: 24 },
  { id: "cat-guide", slug: "cam-nang", name: "Cẩm nang", count: 9 },
  { id: "cat-travel", slug: "du-lich", name: "Du lịch", count: 7 },
  { id: "cat-policy", slug: "chinh-sach", name: "Chính sách", count: 4 },
  { id: "cat-promo", slug: "khuyen-mai", name: "Khuyến mãi", count: 4 }
];

/**
 * Bài viết nổi bật (SCR-PSG-02).
 */
export const featuredArticleFixture: ArticleSummary = {
  id: "art-dalat",
  slug: "da-lat-mua-da-quy",
  title: "Đà Lạt mùa dã quỳ: lịch trình 2 ngày 1 đêm bằng xe giường nằm",
  excerpt:
    "Gợi ý giờ xe đêm từ TP. Hồ Chí Minh, điểm trả gần trung tâm và những cung đường ngắm hoa đẹp nhất tháng 10 – 11.",
  category: "DU LỊCH",
  categorySlug: "du-lich",
  publishedDateText: "02/10/2026",
  readingTimeMinutes: 5,
  viewsCountText: "3.240 lượt xem",
  coverImageUrl:
    "https://images.unsplash.com/photo-1506744038136-46273834b3fb?auto=format&fit=crop&w=1200&q=80",
  isFeatured: true
};

/**
 * Danh sách 6 bài viết cẩm nang mẫu (SCR-PSG-02).
 */
export const articlesListFixture: readonly ArticleSummary[] = [
  {
    id: "art-01",
    slug: "meo-chon-cho-tren-xe-giuong-nam",
    title: "Mẹo chọn chỗ trên xe giường nằm",
    excerpt: "Tầng trên hay tầng dưới, đầu xe hay cuối xe — chọn sao cho hợp với chuyến đêm.",
    category: "CẨM NANG",
    categorySlug: "cam-nang",
    publishedDateText: "28/09/2026",
    viewsCountText: "2.105 lượt xem",
    coverImageUrl:
      "https://images.unsplash.com/photo-1544620347-c4fd4a3d5957?auto=format&fit=crop&w=600&q=80"
  },
  {
    id: "art-02",
    slug: "top-8-quan-pho-bo-tru-danh-doc-ql1",
    title: "Top 8 quán phở bò trứ danh dọc QL1 Bắc – Trung",
    excerpt: "Những điểm dừng chân ăn sáng được tài xế đường dài truyền tai nhau.",
    category: "DU LỊCH",
    categorySlug: "du-lich",
    publishedDateText: "21/09/2026",
    viewsCountText: "4.870 lượt xem",
    coverImageUrl:
      "https://images.unsplash.com/photo-1582878826629-29b7ad1cdc43?auto=format&fit=crop&w=600&q=80"
  },
  {
    id: "art-03",
    slug: "quy-dinh-moi-ve-hanh-ly-xe-khach-2026",
    title: "Quy định mới về hành lý xe khách 2026",
    excerpt: "Trọng lượng ký gửi, hàng cấm mang và cách khai báo hàng giá trị cao.",
    category: "CHÍNH SÁCH",
    categorySlug: "chinh-sach",
    publishedDateText: "15/09/2026",
    viewsCountText: "1.432 lượt xem",
    coverImageUrl:
      "https://images.unsplash.com/photo-1553531384-cc64ac80f931?auto=format&fit=crop&w=600&q=80"
  },
  {
    id: "art-04",
    slug: "di-xe-dem-an-toan-cho-gia-dinh-co-tre-nho",
    title: "Đi xe đêm an toàn cho gia đình có trẻ nhỏ",
    excerpt: "Chuẩn bị gì trước chuyến, chọn giường đôi hay hai giường đơn cạnh nhau.",
    category: "CẨM NANG",
    categorySlug: "cam-nang",
    publishedDateText: "09/09/2026",
    viewsCountText: "986 lượt xem",
    coverImageUrl:
      "https://images.unsplash.com/photo-1476514525535-07fb3b4ae5f1?auto=format&fit=crop&w=600&q=80"
  },
  {
    id: "art-05",
    slug: "ha-long-cuoi-tuan-di-xe-nao-tien",
    title: "Hạ Long cuối tuần: đi xe nào tiện?",
    excerpt: "So sánh giờ chạy, điểm đón trong nội thành Hà Nội và điểm trả gần bến tàu.",
    category: "DU LỊCH",
    categorySlug: "du-lich",
    publishedDateText: "03/09/2026",
    viewsCountText: "2.754 lượt xem",
    coverImageUrl:
      "https://images.unsplash.com/photo-1528127269322-539801943592?auto=format&fit=crop&w=600&q=80"
  },
  {
    id: "art-06",
    slug: "cach-dung-voucher-vxn-plus-khi-dat-ve",
    title: "Cách dùng voucher VXN Plus khi đặt vé",
    excerpt: "Đổi điểm lấy voucher, lưu mã vào ví và chọn ưu đãi ở bước thông tin hành khách.",
    category: "KHUYẾN MÃI",
    categorySlug: "khuyen-mai",
    publishedDateText: "30/08/2026",
    viewsCountText: "1.118 lượt xem",
    coverImageUrl:
      "https://images.unsplash.com/photo-1518684079-3c830dcef090?auto=format&fit=crop&w=600&q=80"
  }
];

/**
 * Chi tiết bài viết cẩm nang (SCR-PSG-37 - Figma 1449:20924).
 */
export const articleDetailFixture: ArticleDetail = {
  ...featuredArticleFixture,
  authorName: "Vé Xe Nhanh",
  leadParagraph:
    "Cuối tháng 10, dã quỳ nở vàng hai bên các con dốc dẫn vào Đà Lạt. Đi xe giường nằm chuyến đêm từ TP. Hồ Chí Minh giúp bạn ngủ trọn giấc và có mặt ở trung tâm thành phố lúc trời vừa sáng.",
  sections: [
    {
      heading: "Chọn giờ xe và điểm đón",
      content:
        "Các chuyến 22:00 – 23:00 đến Đà Lạt khoảng 05:00 – 06:00 hôm sau. Nếu ở xa bến xe, hãy chọn điểm đón là văn phòng nhà xe: nhà xe trung chuyển miễn phí giữa văn phòng và bến.",
      tips: [
        "Đặt vé trước 2 – 3 ngày vào cuối tuần để còn giường tầng dưới.",
        "Giường đôi phù hợp cho hai người đi cùng; chỗ được bán nguyên giường.",
        "Có mặt tại điểm đón trước giờ khởi hành 30 phút."
      ]
    },
    {
      heading: "Lịch trình gợi ý",
      content:
        "Ngày 1: ăn sáng, săn mây ở đồi chè Cầu Đất, chiều dạo quanh hồ Xuân Hương. Ngày 2: cung đường dã quỳ hướng Tà Nung, mua đặc sản rồi lên chuyến xe tối về lại thành phố."
    }
  ],
  relatedRoute: {
    name: "TP. Hồ Chí Minh → Đà Lạt",
    frequencyText: "12 chuyến mỗi ngày · từ 190.000đ",
    fromPriceVnd: "190000",
    searchHref: "/trips?from=TP.+H%E1%BB%93+Ch%C3%AD+Minh&to=%C4%90%C3%A0+L%E1%BA%A1t"
  },
  relatedArticles: [
    {
      id: "rel-01",
      slug: "ha-long-cuoi-tuan-di-xe-nao-tien",
      title: "Hạ Long cuối tuần: đi xe nào tiện?",
      publishedDateText: "03/09/2026",
      coverImageUrl:
        "https://images.unsplash.com/photo-1528127269322-539801943592?auto=format&fit=crop&w=200&q=80"
    },
    {
      id: "rel-02",
      slug: "top-8-quan-pho-bo-tru-danh-doc-ql1",
      title: "Top 8 quán phở bò trứ danh dọc QL1 Bắc – Trung",
      publishedDateText: "21/09/2026",
      coverImageUrl:
        "https://images.unsplash.com/photo-1546069901-ba9599a7e63c?auto=format&fit=crop&w=200&q=80"
    },
    {
      id: "rel-03",
      slug: "hue-mua-mua-3-diem-tru-chan-gan-ben-xe",
      title: "Huế mùa mưa: 3 điểm trú chân gần bến xe",
      publishedDateText: "12/08/2026",
      coverImageUrl:
        "https://images.unsplash.com/photo-1506744038136-46273834b3fb?auto=format&fit=crop&w=200&q=80"
    }
  ]
};

/**
 * Danh sách chuyên mục và câu hỏi thường gặp FAQ (SCR-PSG-03 - Figma 1449:21249).
 */
export const faqGroupsFixture: readonly FaqGroup[] = [
  {
    id: "booking-payment",
    title: "Đặt vé và thanh toán",
    count: 8,
    questions: [
      {
        id: "q-01",
        question: "Tôi có cần tài khoản để đặt vé không?",
        answer:
          "Không. Bạn có thể đặt vé với tư cách khách vãng lai, chỉ cần email liên hệ để nhận vé và tra cứu sau này. Có tài khoản, bạn lưu được lịch sử vé, hành khách thường đi và tích điểm VXN Plus."
      },
      {
        id: "q-02",
        question: "Chỗ tôi chọn được giữ trong bao lâu?",
        answer:
          "Chỗ bạn chọn được giữ trong vòng 10 phút để bạn điền thông tin và thanh toán. Quá thời gian này, hệ thống sẽ tự động nhả chỗ cho hành khách khác."
      },
      {
        id: "q-03",
        question: "Tôi thanh toán bằng những phương thức nào?",
        answer:
          "Vé Xe Nhanh hỗ trợ thanh toán an toàn trực tuyến qua Cổng VNPay (quét mã VNPAY-QR, thẻ ATM nội địa, thẻ quốc tế Visa/Mastercard) và Ví điện tử MoMo."
      },
      {
        id: "q-04",
        question: "Thanh toán xong nhưng chưa nhận được vé thì làm gì?",
        answer:
          "Hệ thống gửi vé điện tử QR vào email của bạn ngay sau khi thanh toán thành công. Nếu chưa thấy, vui lòng kiểm tra hộp thư rác (Spam) hoặc dùng tính năng Tra cứu vé bằng email đặt vé."
      },
      {
        id: "q-05",
        question: "Giường đôi / cabin đôi được bán như thế nào?",
        answer:
          "Giường đôi hoặc cabin đôi được bán nguyên giường/khoang cho 2 hành khách đi cùng. Giá vé hiển thị là giá trọn gói cho toàn bộ giường."
      },
      {
        id: "q-06",
        question: "Một đơn dùng được mấy mã giảm giá hoặc voucher?",
        answer:
          "Mỗi đơn hàng áp dụng tối đa một voucher đổi điểm hoặc một mã khuyến mãi công khai."
      },
      {
        id: "q-07",
        question: "Tiền vé của tôi được giữ ở đâu trước khi chuyến chạy?",
        answer:
          "Tiền thanh toán của bạn được nền tảng Vé Xe Nhanh giữ an toàn cho đến khi chuyến xe hoàn thành và trả khách an toàn rồi mới đối soát thanh toán với nhà xe."
      },
      {
        id: "q-08",
        question: "Vì sao tôi không tìm thấy chuyến theo điểm đón mong muốn?",
        answer:
          "Tùy vào quy định tuyến và giấy phép vận tải, một số điểm đón chỉ phục vụ trung chuyển từ văn phòng nhà xe. Bạn hãy kiểm tra danh sách điểm đón chi tiết trong bước chọn chỗ."
      }
    ]
  },
  {
    id: "eticket-boarding",
    title: "Vé điện tử và lên xe",
    count: 6,
    questions: [
      {
        id: "q-09",
        question: "Có cần in vé giấy trước khi ra bến xe không?",
        answer:
          "Không cần. Bạn chỉ cần xuất trình mã vé điện tử QR trên màn hình điện thoại cho tài xế hoặc phụ xe khi lên xe."
      }
    ]
  },
  {
    id: "cancel-refund",
    title: "Hủy vé và hoàn tiền",
    count: 7,
    questions: [
      {
        id: "q-10",
        question: "Quy định hủy vé và tỷ lệ hoàn tiền như thế nào?",
        answer:
          "Chính sách hủy vé và tỷ lệ hoàn tiền tuân thủ chính sách của từng chuyến xe do nhà xe công bố, được lưu cùng đơn đặt vé của bạn."
      }
    ]
  },
  {
    id: "account-auth",
    title: "Tài khoản và đăng nhập",
    count: 5,
    questions: [
      {
        id: "q-11",
        question: "Tài khoản Vé Xe Nhanh có mật khẩu không?",
        answer:
          "Không. Tài khoản hành khách sử dụng đăng nhập không mật khẩu (passwordless) qua mã OTP gửi về email hoặc qua tài khoản Google, Facebook, Apple."
      }
    ]
  },
  {
    id: "plus-vouchers",
    title: "VXN Plus và voucher",
    count: 6,
    questions: [
      {
        id: "q-12",
        question: "Điểm thưởng VXN Plus được tính như thế nào?",
        answer:
          "Điểm được cộng tự động sau khi chuyến xe hoàn thành, dựa trên số tiền thực trả nhân với hệ số phân hạng thành viên của bạn."
      }
    ]
  },
  {
    id: "complaints-support",
    title: "Khiếu nại và hỗ trợ",
    count: 4,
    questions: [
      {
        id: "q-13",
        question: "Làm thế nào để khiếu nại về chất lượng chuyến đi?",
        answer:
          "Bạn có thể gửi khiếu nại trực tuyến trong mục Hỗ trợ trên website hoặc ứng dụng, đính kèm ảnh và chi tiết sự cố trong vòng 48 giờ sau chuyến đi."
      }
    ]
  }
];

/**
 * Dữ liệu văn bản pháp lý (SCR-PSG-06 - Figma 1449:22136).
 */
export const legalTermsDocumentFixture: LegalDocumentData = {
  slug: "terms-of-service",
  title: "Điều khoản sử dụng",
  effectiveDateText: "01/10/2026",
  lastUpdatedText: "25/09/2026",
  noteText:
    "Nội dung minh họa bố cục — văn bản pháp lý chính thức do Vé Xe Nhanh ban hành sẽ thay thế phần này.",
  tableOfContents: [
    { id: "sec-01", title: "1. Phạm vi áp dụng" },
    { id: "sec-02", title: "2. Tài khoản và xác thực" },
    { id: "sec-03", title: "3. Đặt vé và thanh toán" },
    { id: "sec-04", title: "4. Hủy vé và hoàn tiền" },
    { id: "sec-05", title: "5. Trách nhiệm các bên" },
    { id: "sec-06", title: "6. Dữ liệu cá nhân" },
    { id: "sec-07", title: "7. Khiếu nại và tranh chấp" },
    { id: "sec-08", title: "8. Liên hệ" }
  ],
  sections: [
    {
      id: "sec-01",
      title: "1. Phạm vi áp dụng",
      paragraphs: [
        "Vé Xe Nhanh là nền tảng trung gian kết nối hành khách với các nhà xe đã được xác minh. Vé do nhà xe cung cấp; Vé Xe Nhanh hỗ trợ tìm chuyến, đặt chỗ, thanh toán và giải quyết khiếu nại.",
        "Điều khoản này áp dụng cho mọi người dùng website và ứng dụng Vé Xe Nhanh, kể cả khách đặt vé không đăng nhập."
      ]
    },
    {
      id: "sec-02",
      title: "2. Tài khoản và xác thực",
      paragraphs: [
        "Hành khách đăng nhập bằng mã xác minh gửi qua email hoặc tài khoản Google, Facebook, Apple. Tài khoản hành khách không sử dụng mật khẩu.",
        "Một số thao tác nhạy cảm như hủy vé hoặc đổi email cần xác minh lại bằng mã OTP."
      ]
    },
    {
      id: "sec-03",
      title: "3. Đặt vé và thanh toán",
      paragraphs: [
        "Chỗ được giữ tạm trong thời gian giới hạn kể từ khi bạn chọn. Đơn chưa thanh toán trong thời gian này sẽ hết hạn và chỗ được nhả.",
        "Tiền thanh toán được Vé Xe Nhanh giữ cho đến khi chuyến hoàn thành rồi mới đối soát với nhà xe."
      ]
    },
    {
      id: "sec-04",
      title: "4. Hủy vé và hoàn tiền",
      paragraphs: [
        "Điều kiện hủy và mức hoàn tiền theo chính sách của từng chuyến, được hiển thị trước khi đặt và lưu cùng đơn tại thời điểm đặt."
      ]
    },
    {
      id: "sec-05",
      title: "5. Trách nhiệm các bên",
      paragraphs: [
        "Nhà xe có trách nhiệm đón đúng giờ, phương tiện đảm bảo an toàn kỹ thuật theo đăng kiểm và tuân thủ các quy định vận tải.",
        "Hành khách có trách nhiệm có mặt tại điểm đón trước 30 phút, mang giấy tờ tùy thân hợp lệ và tuân thủ nội quy trên xe."
      ]
    },
    {
      id: "sec-06",
      title: "6. Dữ liệu cá nhân",
      paragraphs: [
        "Chúng tôi cam kết bảo mật thông tin hành khách theo quy định pháp luật về bảo vệ dữ liệu cá nhân. Dữ liệu chỉ dùng để vận hành chuyến và hỗ trợ khách hàng."
      ]
    },
    {
      id: "sec-07",
      title: "7. Khiếu nại và tranh chấp",
      paragraphs: [
        "Mọi khiếu nại được tiếp nhận qua cổng hỗ trợ trực tuyến và xử lý theo quy trình đối soát công khai giữa hành khách, nền tảng và nhà xe."
      ]
    },
    {
      id: "sec-08",
      title: "8. Liên hệ",
      paragraphs: [
        "Tổng đài CSKH 1900 6067 hoặc email support@vexenhanh.vn (hỗ trợ 24/7)."
      ]
    }
  ]
};
