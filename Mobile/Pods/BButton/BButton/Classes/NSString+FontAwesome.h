//
//  NSString+FontAwesome.h
//
//  Created by Pit Garbe on 27.09.12.
//  Updated to Font Awesome 3.1.1 on 17.05.2013.
//  Copyright (c) 2012 Pit Garbe. All rights reserved.
//
//  https://github.com/leberwurstsaft/FontAwesome-for-iOS
//
//
//  * The Font Awesome font is licensed under the SIL Open Font License
//  http://scripts.sil.org/OFL
//
//
// * Font Awesome CSS, LESS, and SASS files are licensed under the MIT License
//  http://opensource.org/licenses/mit-license.html
//
//
//  * The Font Awesome pictograms are licensed under the CC BY 3.0 License
//  http://creativecommons.org/licenses/by/3.0
//
//
//  * Attribution is no longer required in Font Awesome 3.0, but much appreciated:
//  "Font Awesome by Dave Gandy - http://fortawesome.github.com/Font-Awesome"
//
//
//  -----------------------------------------
//  Edited and refactored by Jesse Squires on 2 April, 2013.
//
//  http://github.com/jessesquires/BButton
//
//  http://hexedbits.com
//

#import <Foundation/Foundation.h>

/**
 *  A string constant for the Font Awesome font family name.
 */
extern NSString * const kFontAwesomeFont;

/**
 *  A constant describing the available Font Awesome Icons.
 */
typedef NS_ENUM(NSUInteger, FAIcon) {
    FAIconGlass,
    FAIconMusic,
    FAIconSearch,
    FAIconEnvelope,
    FAIconHeart,
    FAIconStar,
    FAIconStarEmpty,
    FAIconUser,
    FAIconFilm,
    FAIconThLarge,
    FAIconTh,
    FAIconThList,
    FAIconOk,
    FAIconRemove,
    FAIconZoomIn,
    FAIconZoomOut,
    FAIconOff,
    FAIconSignal,
    FAIconCog,
    FAIconTrash,
    FAIconHome,
    FAIconFile,
    FAIconTime,
    FAIconRoad,
    FAIconDownloadAlt,
    FAIconDownload,
    FAIconUpload,
    FAIconInbox,
    FAIconPlayCircle,
    FAIconRepeat,
    FAIconRefresh,
    FAIconListAlt,
    FAIconLock,
    FAIconFlag,
    FAIconHeadphones,
    FAIconVolumeOff,
    FAIconVolumeDown,
    FAIconVolumeUp,
    FAIconQrcode,
    FAIconBarcode,
    FAIconTag,
    FAIconTags,
    FAIconBook,
    FAIconBookmark,
    FAIconPrint,
    FAIconCamera,
    FAIconFont,
    FAIconBold,
    FAIconItalic,
    FAIconTextHeight,
    FAIconTextWidth,
    FAIconAlignLeft,
    FAIconAlignCenter,
    FAIconAlignRight,
    FAIconAlignJustify,
    FAIconList,
    FAIconIndentLeft,
    FAIconIndentRight,
    FAIconFacetimeVideo,
    FAIconPicture,
    FAIconPencil,
    FAIconMapMarker,
    FAIconAdjust,
    FAIconTint,
    FAIconEdit,
    FAIconShare,
    FAIconCheck,
    FAIconMove,
    FAIconStepBackward,
    FAIconFastBackward,
    FAIconBackward,
    FAIconPlay,
    FAIconPause,
    FAIconStop,
    FAIconForward,
    FAIconFastForward,
    FAIconStepForward,
    FAIconEject,
    FAIconChevronLeft,
    FAIconChevronRight,
    FAIconPlusSign,
    FAIconMinusSign,
    FAIconRemoveSign,
    FAIconOkSign,
    FAIconQuestionSign,
    FAIconInfoSign,
    FAIconScreenshot,
    FAIconRemoveCircle,
    FAIconOkCircle,
    FAIconBanCircle,
    FAIconArrowLeft,
    FAIconArrowRight,
    FAIconArrowUp,
    FAIconArrowDown,
    FAIconShareAlt,
    FAIconResizeFull,
    FAIconResizeSmall,
    FAIconPlus,
    FAIconMinus,
    FAIconAsterisk,
    FAIconExclamationSign,
    FAIconGift,
    FAIconLeaf,
    FAIconFire,
    FAIconEyeOpen,
    FAIconEyeClose,
    FAIconWarningSign,
    FAIconPlane,
    FAIconCalendar,
    FAIconRandom,
    FAIconComment,
    FAIconMagnet,
    FAIconChevronUp,
    FAIconChevronDown,
    FAIconRetweet,
    FAIconShoppingCart,
    FAIconFolderClose,
    FAIconFolderOpen,
    FAIconResizeVertical,
    FAIconResizeHorizontal,
    FAIconBarChart,
    FAIconTwitterSign,
    FAIconFacebookSign,
    FAIconCameraRetro,
    FAIconKey,
    FAIconCogs,
    FAIconComments,
    FAIconThumbsUp,
    FAIconThumbsDown,
    FAIconStarHalf,
    FAIconHeartEmpty,
    FAIconSignout,
    FAIconLinkedinSign,
    FAIconPushpin,
    FAIconExternalLink,
    FAIconSignin,
    FAIconTrophy,
    FAIconGithubSign,
    FAIconUploadAlt,
    FAIconLemon,
    FAIconPhone,
    FAIconCheckEmpty,
    FAIconBookmarkEmpty,
    FAIconPhoneSign,
    FAIconTwitter,
    FAIconFacebook,
    FAIconGithub,
    FAIconUnlock,
    FAIconCreditCard,
    FAIconRss,
    FAIconHdd,
    FAIconBullhorn,
    FAIconBell,
    FAIconCertificate,
    FAIconHandRight,
    FAIconHandLeft,
    FAIconHandUp,
    FAIconHandDown,
    FAIconCircleArrowLeft,
    FAIconCircleArrowRight,
    FAIconCircleArrowUp,
    FAIconCircleArrowDown,
    FAIconGlobe,
    FAIconWrench,
    FAIconTasks,
    FAIconFilter,
    FAIconBriefcase,
    FAIconFullscreen,
    FAIconGroup,
    FAIconLink,
    FAIconCloud,
    FAIconBeaker,
    FAIconCut,
    FAIconCopy,
    FAIconPaperClip,
    FAIconSave,
    FAIconSignBlank,
    FAIconReorder,
    FAIconListUl,
    FAIconListOl,
    FAIconStrikethrough,
    FAIconUnderline,
    FAIconTable,
    FAIconMagic,
    FAIconTruck,
    FAIconPinterest,
    FAIconPinterestSign,
    FAIconGooglePlusSign,
    FAIconGooglePlus,
    FAIconMoney,
    FAIconCaretDown,
    FAIconCaretUp,
    FAIconCaretLeft,
    FAIconCaretRight,
    FAIconColumns,
    FAIconSort,
    FAIconSortDown,
    FAIconSortUp,
    FAIconEnvelopeAlt,
    FAIconLinkedin,
    FAIconUndo,
    FAIconLegal,
    FAIconDashboard,
    FAIconCommentAlt,
    FAIconCommentsAlt,
    FAIconBolt,
    FAIconSitemap,
    FAIconUmbrella,
    FAIconPaste,
    FAIconLightBulb,
    FAIconExchange,
    FAIconCloudDownload,
    FAIconCloudUpload,
    FAIconUserMd,
    FAIconStethoscope,
    FAIconSuitecase,
    FAIconBellAlt,
    FAIconCoffee,
    FAIconFood,
    FAIconFileAlt,
    FAIconBuilding,
    FAIconHospital,
    FAIconAmbulance,
    FAIconMedkit,
    FAIconFighterJet,
    FAIconBeer,
    FAIconHSign,
    FAIconPlusSignAlt,
    FAIconDoubleAngleLeft,
    FAIconDoubleAngleRight,
    FAIconDoubleAngleUp,
    FAIconDoubleAngleDown,
    FAIconAngleLeft,
    FAIconAngleRight,
    FAIconAngleUp,
    FAIconAngleDown,
    FAIconDesktop,
    FAIconLaptop,
    FAIconTablet,
    FAIconMobilePhone,
    FAIconCircleBlank,
    FAIconQuoteLeft,
    FAIconQuoteRight,
    FAIconSpinner,
    FAIconCircle,
    FAIconReply,
    FAIconFolderCloseAlt,
    FAIconFolderOpenAlt,
    FAIconExpandAlt,
    FAIconCollapseAlt,
    FAIconSmile,
    FAIconFrown,
    FAIconMeh,
    FAIconGamepad,
    FAIconKeyboard,
    FAIconFlagAlt,
    FAIconFlagCheckered,
    FAIconTerminal,
    FAIconCode,
    FAIconReplyAll,
    FAIconStarHalfAlt,
    FAIconLocationArrow,
    FAIconCrop,
    FAIconCodeFork,
    FAIconUnlink,
    FAIconQuestion,
    FAIconInfo,
    FAIconExclamation,
    FAIconSuperscript,
    FAIconSubscript,
    FAIconEraser,
    FAIconPuzzlePiece,
    FAIconMicrophone,
    FAIconMicrophoneOff,
    FAIconShield,
    FAIconCalendarEmpty,
    FAIconFireExtinguisher,
    FAIconRocket,
    FAIconMaxCDN,
    FAIconChevronSignLeft,
    FAIconChevronSignRight,
    FAIconChevronSignUp,
    FAIconChevronSignDown,
    FAIconHTML5,
    FAIconCSS3,
    FAIconFAIconAnchor,
    FAIconUnlockAlt,
    FAIconBullseye,
    FAIconEllipsisHorizontal,
    FAIconEllipsisVertical,
    FAIconRSS,
    FAIconPlaySign,
    FAIconTicket,
    FAIconMinusSignAlt,
    FAIconCheckMinus,
    FAIconLevelUp,
    FAIconLevelDown,
    FAIconCheckSign,
    FAIconEditSign,
    FAIconExternalLinkSign,
    FAIconShareSign
};

@interface NSString (AwesomeString)

//creates a string with the font awesome character
+(NSString*)awesomeIcon:(FAIcon)index;

@end

@interface NSString (FontAwesome)

/**
 *
 *  @return An array of all the font awesome icon strings.
 */
+ (NSArray *)fa_allFontAwesomeStrings;

/**
 *
 *  @param strings An array of all the font awesome icon strings.
 *  @param icon    A constant describing a font awesome icon.
 *
 *  @return The font awesome icon string associated with the given icon.
 */
+ (NSString *)fa_stringFromFontAwesomeStrings:(NSArray *)strings
                                      forIcon:(FAIcon)icon;

@end