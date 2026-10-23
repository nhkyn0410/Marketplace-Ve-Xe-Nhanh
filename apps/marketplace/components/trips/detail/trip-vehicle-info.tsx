"use client";

import { Wifi, Snowflake, Droplets, Zap, Bed, EyeOff } from "lucide-react";

import { TripDetailData } from "../../../lib/data/types";


/**
 * Thuộc tính của khối thông tin xe.
 */
interface TripVehicleInfoProps {
  readonly trip: TripDetailData;
}

/**
 * Biểu tượng tương ứng với từng tiện ích.
 */
function getAmenityIcon(amenity: string) {
  switch (amenity) {
    case "WiFi":
      return <Wifi className="w-3.5 h-3.5 text-neutral-600" />;
    case "Điều hòa":
      return <Snowflake className="w-3.5 h-3.5 text-neutral-600" />;
    case "Nước uống":
      return <Droplets className="w-3.5 h-3.5 text-neutral-600" />;
    case "Cổng sạc":
      return <Zap className="w-3.5 h-3.5 text-neutral-600" />;
    case "Chăn gối":
      return <Bed className="w-3.5 h-3.5 text-neutral-600" />;
    case "Rèm che":
      return <EyeOff className="w-3.5 h-3.5 text-neutral-600" />;
    default:
      return null;
  }
}

/**
 * Khối hiển thị thông tin xe, bộ sưu tập ảnh và tiện nghi (SCR-PSG-16).
 */
export function TripVehicleInfo({ trip }: TripVehicleInfoProps) {
  const mainPhoto = trip.photos[0];
  const sidePhotos = trip.photos.slice(1, 5);

  return (
    <div className="bg-white rounded-2xl border border-neutral-200 p-6 shadow-xs space-y-5">
      <div>
        <h3 className="text-base font-semibold text-neutral-900">
          Thông tin xe
        </h3>
        <p className="text-xs text-neutral-500 mt-0.5">
          {trip.vehicleTypeName}
        </p>
      </div>

      {/* Lưới hình ảnh xe */}
      {mainPhoto && <div className="space-y-2">
        <div className="grid grid-cols-1 md:grid-cols-2 gap-2 h-72 rounded-xl overflow-hidden">
          {/* Ảnh lớn bên trái */}
          <div className="relative h-full w-full bg-neutral-100 overflow-hidden">
            {mainPhoto && (
              <img
                src={mainPhoto.url}
                alt={mainPhoto.caption}
                className="w-full h-full object-cover hover:scale-105 transition-transform duration-300"
              />
            )}
          </div>

          {/* Lưới 4 ảnh nhỏ bên phải */}
          <div className="grid grid-cols-2 gap-2 h-full">
            {sidePhotos.map((photo, idx) => {
              const isLast = idx === 3 && trip.remainingPhotosCount > 0;
              return (
                <div key={photo.url} className="relative h-full w-full bg-neutral-100 overflow-hidden rounded-md">
                  <img
                    src={photo.url}
                    alt={photo.caption}
                    className="w-full h-full object-cover hover:scale-105 transition-transform duration-300"
                  />
                  {isLast && (
                    <div className="absolute inset-0 bg-black/60 backdrop-blur-xs flex items-center justify-center text-white font-medium text-sm">
                      +{trip.remainingPhotosCount} ảnh
                    </div>
                  )}
                </div>
              );
            })}
          </div>
        </div>

        <p className="text-[11px] text-neutral-400 italic">
          {trip.photosCaption}
        </p>
      </div>}
      {!mainPhoto && <p className="text-xs text-neutral-500">Nhà xe chưa cung cấp ảnh cho chuyến này.</p>}

      {/* Tiện nghi */}
      <div className="pt-2 border-t border-neutral-100">
        <span className="text-xs font-medium text-neutral-700 block mb-2.5">
          Tiện nghi
        </span>
        {!trip.amenities.length && <p className="text-xs text-neutral-500">Chưa có thông tin tiện nghi.</p>}
        <div className="flex flex-wrap gap-2">
          {trip.amenities.map((amenity) => (
            <div
              key={amenity}
              className="flex items-center gap-1.5 px-3 py-1.5 rounded-lg bg-neutral-50 border border-neutral-200/80 text-xs text-neutral-700 font-medium"
            >
              {getAmenityIcon(amenity)}
              <span>{amenity}</span>
            </div>
          ))}
        </div>
      </div>
    </div>
  );
}
