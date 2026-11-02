import type {
  UserProfileData,
  NotificationSettingsData,
  UserNotificationItem,
  UserSessionItem,
  UserReviewsData
} from "../../data/types";

/**
 * Fixture màn hình Đăng nhập (SCR-PSG-07 - node 1447:16634).
 */
export const loginFixture = {
  email: "khach.nguyen@gmail.com"
};

/**
 * Fixture màn hình Tạo tài khoản (SCR-PSG-08 - node 1447:17057).
 */
export const registerFixture = {
  fullName: "Nguyễn Văn Khách",
  email: "khach.nguyen@gmail.com",
  phone: "0901 234 567"
};

/**
 * Fixture màn hình Nhập OTP (SCR-PSG-09 - node 1447:17487).
 */
export const verifyEmailFixture = {
  email: "khach.nguyen@gmail.com",
  maskedEmail: "k***n@gmail.com",
  otpDigits: ["4", "8", "2", "9", "1", "7"],
  expiresInSeconds: 272,
  resendCountdownSeconds: 28,
  remainingAttempts: 5
};

/**
 * Fixture màn hình OAuth callback (SCR-PSG-10 - node 1447:17897).
 */
export const oauthCallbackFixture = {
  provider: "Google",
  email: "khach.nguyen@gmail.com",
  isExistingLinked: true,
  redirectUrl: "/"
};

/**
 * Fixture thông tin hồ sơ tài khoản (SCR-PSG-11 - node 1447:18295).
 */
export const userProfileFixture: UserProfileData = {
  id: "usr-01",
  fullName: "Nguyễn Văn Khách",
  email: "khach.nguyen@gmail.com",
  phone: "0901 234 567",
  dateOfBirth: "12/03/1994",
  gender: "Nam",
  idNumber: "079 *** *** 234",
  tierName: "Hạng Bạc",
  points: 1250,
  periodPoints: 2450,
  pointsNeededNextTier: 2550,
  nextTierName: "Vàng",
  voucherCount: 3,
  ticketsCount: 12,
  savedPassengers: [
    {
      id: "sp-01",
      name: "Nguyễn Văn Khách (tôi)",
      phone: "0901 234 567",
      idNumber: "CCCD 079 *** *** 234",
      isSelf: true
    },
    {
      id: "sp-02",
      name: "Trần Thị Mai",
      phone: "0912 555 678",
      idNumber: "CCCD chưa có",
      isSelf: false
    },
    {
      id: "sp-03",
      name: "Nguyễn Minh Anh",
      phone: "0987 111 222",
      idNumber: "CCCD 079 *** *** 880",
      isSelf: false
    }
  ],
  securityMethods: {
    email: "khach.nguyen@gmail.com",
    googleLinked: true,
    googleLinkedDate: "02/09/2026",
    facebookLinked: false,
    appleLinked: false,
    activeSessionsCount: 3
  }
};

/**
 * Fixture cài đặt thông báo tài khoản (SCR-PSG-12 - node 1447:18811).
 */
export const notificationSettingsFixture: NotificationSettingsData = {
  mandatoryItems: [
    {
      id: "mand-01",
      title: "Bảo mật tài khoản",
      description: "Đăng nhập mới, đổi email, thu hồi phiên.",
      isMandatory: true,
      emailEnabled: true,
      pushEnabled: true
    },
    {
      id: "mand-02",
      title: "Vé và đặt chỗ",
      description: "Xác nhận đặt vé, vé điện tử, check-in.",
      isMandatory: true,
      emailEnabled: true,
      pushEnabled: true
    },
    {
      id: "mand-03",
      title: "Thanh toán và hoàn tiền",
      description: "Kết quả thanh toán, tiến độ hoàn tiền.",
      isMandatory: true,
      emailEnabled: true,
      pushEnabled: true
    },
    {
      id: "mand-04",
      title: "Đổi / hủy chuyến",
      description: "Nhà xe đổi giờ, đổi xe hoặc hủy chuyến bạn đã đặt.",
      isMandatory: true,
      emailEnabled: true,
      pushEnabled: true
    },
    {
      id: "mand-05",
      title: "Khiếu nại và tranh chấp",
      description: "Phản hồi mới, yêu cầu bổ sung, kết quả xử lý.",
      isMandatory: true,
      emailEnabled: true,
      pushEnabled: true
    }
  ],
  optionalItems: [
    {
      id: "opt-01",
      title: "Nhắc trước giờ khởi hành",
      description: "Nhắc trước chuyến 24 giờ và 2 giờ.",
      isMandatory: false,
      emailEnabled: true,
      pushEnabled: true
    },
    {
      id: "opt-02",
      title: "Điểm VXN Plus và hạng thành viên",
      description: "Cộng điểm sau chuyến, thay đổi hạng.",
      isMandatory: false,
      emailEnabled: true,
      pushEnabled: false
    },
    {
      id: "opt-03",
      title: "Điểm sắp hết hạn",
      description: "Nhắc trước khi điểm hết hạn.",
      isMandatory: false,
      emailEnabled: true,
      pushEnabled: true
    },
    {
      id: "opt-04",
      title: "Khuyến mãi và voucher",
      description: "Mã khuyến mãi mới, voucher sắp hết hạn.",
      isMandatory: false,
      emailEnabled: false,
      pushEnabled: false
    },
    {
      id: "opt-05",
      title: "Tin tức và cẩm nang",
      description: "Bài viết mới ở trang Khám phá.",
      isMandatory: false,
      emailEnabled: false,
      pushEnabled: false
    }
  ]
};

/**
 * Fixture thông báo tài khoản (SCR-PSG-12 - node 1447:18811).
 */
export const userNotificationsFixture: readonly UserNotificationItem[] = [
  {
    id: "notif-01",
    title: "Chuyến đi sắp khởi hành",
    content: "Chuyến TP. Hồ Chí Minh → Đà Lạt khởi hành lúc 22:30 hôm nay. Vui lòng có mặt tại điểm đón trước 30 phút.",
    createdAtText: "10 phút trước",
    isRead: false,
    category: "booking"
  },
  {
    id: "notif-02",
    title: "Nhà xe phản hồi khiếu nại KN-20261005-014",
    content: "Phương Nam Travel đã gửi tin nhắn giải quyết khiếu nại chuyến xe của bạn.",
    createdAtText: "Hôm qua lúc 16:45",
    isRead: false,
    category: "system"
  },
  {
    id: "notif-03",
    title: "Tặng voucher giảm 15% cho thành viên",
    content: "Mã GIAM15 vừa được thêm vào ví voucher của bạn nhân dịp cuối tuần.",
    createdAtText: "04/10/2026",
    isRead: true,
    category: "promo"
  }
];

/**
 * Fixture các phiên đăng nhập tài khoản (SCR-PSG-13 - node 1448:18809).
 */
export const userSessionsFixture: readonly UserSessionItem[] = [
  {
    id: "sess-01",
    deviceName: "Chrome trên Windows",
    deviceType: "desktop",
    ipAddress: "113.161.***.***",
    locationText: "TP. Hồ Chí Minh",
    loginDateText: "08/10/2026",
    lastActiveText: "Hoạt động vừa xong",
    isCurrent: true
  },
  {
    id: "sess-02",
    deviceName: "Ứng dụng Vé Xe Nhanh trên Android",
    deviceType: "mobile",
    ipAddress: "14.169.***.***",
    locationText: "TP. Hồ Chí Minh",
    loginDateText: "02/10/2026",
    lastActiveText: "Hoạt động 2 giờ trước",
    isCurrent: false
  },
  {
    id: "sess-03",
    deviceName: "Safari trên iPhone",
    deviceType: "mobile",
    ipAddress: "27.72.***.***",
    locationText: "Đà Lạt",
    loginDateText: "21/09/2026",
    lastActiveText: "Hoạt động 3 ngày trước",
    isCurrent: false
  }
];

/**
 * Fixture đánh giá chuyến xe của tôi (SCR-PSG-14 - node 1448:19193).
 */
export const userReviewsFixture: UserReviewsData = {
  pendingTrips: [
    {
      tripId: "tr-pend-01",
      operatorName: "Phương Nam Travel",
      routeName: "TP. Hồ Chí Minh → Nha Trang",
      completedDateText: "Hoàn thành 20/09/2026",
      bookingCode: "VXN-7Q2L5B",
      initialRating: 4,
      initialComment:
        "Xe sạch, tài xế chạy êm. Điểm đón dễ tìm, nhân viên hỗ trợ hành lý nhiệt tình."
    }
  ],
  completedReviews: [
    {
      id: "rev-01",
      operatorName: "Phương Nam Travel",
      routeName: "TP. Hồ Chí Minh → Đà Lạt",
      reviewedDateText: "Đánh giá ngày 05/09/2026",
      rating: 5,
      content: "Khởi hành đúng giờ, giường rộng và có cổng sạc. Sẽ đi lại.",
      statusLabel: "Đang hiển thị"
    },
    {
      id: "rev-02",
      operatorName: "Hoàng Long Coach",
      routeName: "TP. Hồ Chí Minh → Vũng Tàu",
      reviewedDateText: "Đánh giá ngày 18/08/2026",
      rating: 3,
      content: "Xe đến trễ 20 phút so với giờ in trên vé.",
      statusLabel: "Đang kiểm duyệt"
    }
  ]
};
