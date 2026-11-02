import type { MyComplaintsData, NewComplaintPayload, GuestComplaintFormData } from "../../data/types";

/**
 * Fixture dữ liệu màn hình Khiếu nại của tôi (SCR-PSG-30 - node 1446:16033).
 */
export const myComplaintsFixture: MyComplaintsData = {
  activeComplaints: [
    {
      id: "kn-01",
      code: "KN-20261005-014",
      title: "Xe khởi hành trễ 45 phút",
      bookingCode: "VXN-7Q2L5B",
      updatedAtText: "06/10/2026",
      status: "needs_info",
      statusLabel: "Chờ bạn bổ sung",
      statusTone: "warning"
    },
    {
      id: "kn-02",
      code: "KN-20260928-007",
      title: "Chưa nhận được tiền hoàn sau khi hủy vé",
      bookingCode: "VXN-1C8N3R",
      updatedAtText: "30/09/2026",
      status: "processing",
      statusLabel: "Đang xử lý",
      statusTone: "neutral"
    }
  ],
  closedComplaints: [
    {
      id: "kn-03",
      code: "KN-20260812-002",
      title: "Máy lạnh trên xe bị hỏng",
      bookingCode: "VXN-4H9P6C",
      updatedAtText: "15/08/2026",
      status: "resolved",
      statusLabel: "Đã giải quyết",
      statusTone: "success"
    },
    {
      id: "kn-04",
      code: "KN-20260705-001",
      title: "Tài xế đón khách sai điểm hẹn",
      bookingCode: "VXN-2J8K1L",
      updatedAtText: "08/07/2026",
      status: "closed",
      statusLabel: "Đã đóng",
      statusTone: "neutral"
    },
    {
      id: "kn-05",
      code: "KN-20260619-003",
      title: "Hành lý bị thất lạc tạm thời",
      bookingCode: "VXN-5N4M2P",
      updatedAtText: "21/06/2026",
      status: "resolved",
      statusLabel: "Đã giải quyết",
      statusTone: "success"
    }
  ],
  selectedComplaint: {
    id: "kn-01",
    code: "KN-20261005-014",
    title: "Xe khởi hành trễ 45 phút",
    createdAtText: "Mã KN-20261005-014 · Tạo lúc 09:12 · 05/10/2026",
    statusLabel: "Chờ bạn bổ sung",
    statusTone: "warning",
    steps: [
      { label: "Đã tạo", state: "completed" },
      { label: "Đã phân loại", state: "completed" },
      { label: "Chờ bạn bổ sung", state: "current" },
      { label: "Đang xử lý", state: "upcoming" },
      { label: "Đã giải quyết", state: "upcoming" }
    ],
    bookingCode: "VXN-7Q2L5B",
    routeText: "VXN-7Q2L5B · TP. Hồ Chí Minh → Nha Trang",
    category: "Chất lượng dịch vụ",
    noticeWarningText: "Nhà xe yêu cầu bổ sung: ảnh chụp vé hoặc thời điểm xe đến điểm đón. Hạn phản hồi: 10/10/2026.",
    messages: [
      {
        id: "msg-1",
        senderName: "Bạn",
        senderRole: "passenger",
        createdAtText: "05/10/2026 · 09:12",
        content: "Chuyến 22:30 ngày 04/10 đến điểm đón trễ 45 phút và không có thông báo trước cho hành khách.",
        attachments: [
          {
            fileName: "anh-diem-don.jpg",
            fileSizeText: "1,2 MB"
          }
        ]
      },
      {
        id: "msg-2",
        senderName: "CSKH Vé Xe Nhanh",
        senderRole: "platform",
        createdAtText: "05/10/2026 · 10:03",
        content: "Vé Xe Nhanh đã tiếp nhận, phân loại và chuyển nhà xe phản hồi trong 24 giờ."
      },
      {
        id: "msg-3",
        senderName: "Phương Nam Travel",
        senderRole: "operator",
        createdAtText: "06/10/2026 · 08:40",
        content: "Nhà xe xin lỗi về sự chậm trễ. Vui lòng bổ sung ảnh vé hoặc thời điểm xe đến để đối chiếu nhật trình chuyến."
      }
    ]
  }
};

/**
 * Fixture dữ liệu mẫu cho Hộp thoại gửi khiếu nại (SCR-PSG-31 - node 1446:16390).
 */
export const newComplaintModalFixture: NewComplaintPayload = {
  bookingCode: "VXN-8F3K2Q",
  category: "Thanh toán / hoàn tiền",
  suggestedSeverity: "Trung bình",
  title: "Bị trừ tiền hai lần cho một đơn",
  content: "Tôi thanh toán đơn VXN-8F3K2Q qua VNPay lúc 14:12 ngày 08/10 nhưng tài khoản bị trừ 460.000đ hai lần. Nhờ kiểm tra và hoàn lại khoản trừ thừa.",
  attachmentFileNames: ["sao-ke-vnpay.pdf · 320 KB"]
};

/**
 * Fixture dữ liệu mẫu cho Khách vãng lai gửi khiếu nại (SCR-PSG-32 - node 1446:16579).
 */
export const guestComplaintFixture: GuestComplaintFormData = {
  bookingCode: "VXN-4H9P6C",
  email: "hoa.le@gmail.com",
  category: "Chất lượng dịch vụ",
  title: "Xe khởi hành trễ và không bật máy lạnh",
  content: "Chuyến xe xuất bến muộn 30 phút, điều hòa không hoạt động suốt chặng đường từ Sài Gòn đi Đà Lạt gây khó chịu cho hành khách.",
  attachmentFileNames: ["anh-ve-xe.jpg · 1,5 MB"]
};

/**
 * Fixture toàn bộ trang khiếu nại cho khách vãng lai (SCR-PSG-32 - node 1446:16579).
 */
export const guestSupportPageFixture: import("../../data/types").GuestSupportData = {
  session: {
    maskedEmail: "h***e@gmail.com",
    bookingCode: "VXN-4H9P6C",
    expiresInSeconds: 725 // 12:05
  },
  complaints: {
    activeComplaints: [
      {
        id: "kn-guest-01",
        code: "KN-20261005-021",
        title: "Xe khởi hành trễ 45 phút",
        bookingCode: "VXN-4H9P6C",
        updatedAtText: "06/10/2026",
        status: "needs_info",
        statusLabel: "Chờ bạn bổ sung",
        statusTone: "warning"
      }
    ],
    closedComplaints: [],
    selectedComplaint: {
      id: "kn-guest-01",
      code: "KN-20261005-021",
      title: "Xe khởi hành trễ 45 phút",
      createdAtText: "Mã KN-20261005-021 · Tạo lúc 09:12 · 05/10/2026",
      statusLabel: "Chờ bạn bổ sung",
      statusTone: "warning",
      steps: [
        { label: "Đã tạo", state: "completed" },
        { label: "Đã phân loại", state: "completed" },
        { label: "Chờ bạn bổ sung", state: "current" },
        { label: "Đang xử lý", state: "upcoming" },
        { label: "Đã giải quyết", state: "upcoming" }
      ],
      bookingCode: "VXN-4H9P6C",
      routeText: "VXN-4H9P6C · TP. Hồ Chí Minh → Đà Lạt",
      category: "Chất lượng dịch vụ",
      noticeWarningText: "Nhà xe yêu cầu bổ sung: ảnh chụp vé hoặc thời điểm xe đến điểm đón. Hạn phản hồi: 10/10/2026.",
      messages: [
        {
          id: "msg-g1",
          senderName: "Bạn",
          senderRole: "passenger",
          createdAtText: "05/10/2026 · 09:12",
          content: "Chuyến 22:30 ngày 04/10 đến điểm đón trễ 45 phút và không có thông báo trước cho hành khách.",
          attachments: [
            {
              fileName: "anh-diem-don.jpg",
              fileSizeText: "1,2 MB"
            }
          ]
        },
        {
          id: "msg-g2",
          senderName: "CSKH Vé Xe Nhanh",
          senderRole: "platform",
          createdAtText: "05/10/2026 · 10:03",
          content: "Vé Xe Nhanh đã tiếp nhận, phân loại và chuyển nhà xe phản hồi trong 24 giờ."
        },
        {
          id: "msg-g3",
          senderName: "Phương Nam Travel",
          senderRole: "operator",
          createdAtText: "06/10/2026 · 08:40",
          content: "Nhà xe xin lỗi về sự chậm trễ. Vui lòng bổ sung ảnh vé hoặc thời điểm xe đến để đối chiếu nhật trình chuyến."
        }
      ]
    }
  }
};

