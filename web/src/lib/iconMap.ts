import {
  MdPersonOutline,
  MdWorkOutline,
  MdShoppingCart,
  MdFavoriteBorder,
  MdSchool,
  MdHome,
  MdStar,
  MdFlag,
  MdList,
  MdFitnessCenter,
  MdLocalHospital,
  MdRestaurant,
  MdDirectionsCar,
  MdFlightTakeoff,
  MdPets,
  MdMusicNote,
  MdSportsEsports,
  MdBrush,
  MdAccountBalance,
  MdBuild,
} from "react-icons/md";
import { IconType } from "react-icons";

export const iconMap: Record<string, IconType> = {
  person_outline: MdPersonOutline,
  work_outline: MdWorkOutline,
  shopping_cart: MdShoppingCart,
  favorite_border: MdFavoriteBorder,
  school: MdSchool,
  home: MdHome,
  star: MdStar,
  flag: MdFlag,
  list: MdList,
  fitness_center: MdFitnessCenter,
  local_hospital: MdLocalHospital,
  restaurant: MdRestaurant,
  directions_car: MdDirectionsCar,
  flight_takeoff: MdFlightTakeoff,
  pets: MdPets,
  music_note: MdMusicNote,
  sports_esports: MdSportsEsports,
  brush: MdBrush,
  account_balance: MdAccountBalance,
  build: MdBuild,
};

export const defaultIcon = MdList;

export function getIcon(iconName: string): IconType {
  return iconMap[iconName] ?? defaultIcon;
}
