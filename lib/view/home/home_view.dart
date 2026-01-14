import 'package:base_apis/cubit/auth_cubit.dart';
import 'package:base_apis/dio/token_manager.dart';
import 'package:base_apis/view/login/login_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        // Navigate to login if session expired
        if (state.shouldNavigateToLogin == true) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const LoginView()),
            (route) => false,
          );
        }
        // Show error message when there's an error
        if (state.errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage!),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 3),
            ),
          );
        }
      },
      builder: (context, state) {
        final user = state.getMeData;

        if (user == null) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Home'),
              automaticallyImplyLeading: false,
            ),
            body: Center(
              child: state.isLoading == true
                  ? const CircularProgressIndicator()
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          state.errorMessage ?? 'No user data available',
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            context.read<AuthCubit>().getMe();
                          },
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
            ),
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text('Home'),
            automaticallyImplyLeading: false,
            actions: [
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: state.isLoading == true
                    ? null
                    : () {
                        context.read<AuthCubit>().getMe();
                      },
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Token Information Card (at the top)
                Card(
                  color: Colors.blue.shade50,
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.key, color: Colors.blue),
                            const SizedBox(width: 8),
                            const Text(
                              'Active Tokens',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Spacer(),
                            Icon(
                              Icons.check_circle,
                              color: Colors.green,
                              size: 20,
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        _buildTokenRow(
                          'Access Token',
                          TokenManager().accessToken ?? 'N/A',
                          context,
                        ),
                        const Divider(height: 24),
                        _buildTokenRow(
                          'Refresh Token',
                          TokenManager().refreshToken ?? 'N/A',
                          context,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Profile Image
                if (user.image != null)
                  Center(
                    child: CircleAvatar(
                      radius: 60,
                      backgroundImage: NetworkImage(user.image!),
                    ),
                  ),
                const SizedBox(height: 24),

                // Personal Information Section
                const Text(
                  'Personal Information',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),

                _buildInfoCard(
                  title: 'Full Name',
                  value: '${user.firstName ?? ''} ${user.lastName ?? ''}',
                  icon: Icons.person,
                ),
                const SizedBox(height: 12),

                _buildInfoCard(
                  title: 'Maiden Name',
                  value: user.maidenName ?? 'N/A',
                  icon: Icons.badge,
                ),
                const SizedBox(height: 12),

                _buildInfoCard(
                  title: 'Username',
                  value: user.username ?? 'N/A',
                  icon: Icons.account_circle,
                ),
                const SizedBox(height: 12),

                _buildInfoCard(
                  title: 'Email',
                  value: user.email ?? 'N/A',
                  icon: Icons.email,
                ),
                const SizedBox(height: 12),

                _buildInfoCard(
                  title: 'Phone',
                  value: user.phone ?? 'N/A',
                  icon: Icons.phone,
                ),
                const SizedBox(height: 12),

                _buildInfoCard(
                  title: 'Age',
                  value: user.age?.toString() ?? 'N/A',
                  icon: Icons.cake,
                ),
                const SizedBox(height: 12),

                _buildInfoCard(
                  title: 'Birth Date',
                  value: user.birthDate ?? 'N/A',
                  icon: Icons.calendar_today,
                ),
                const SizedBox(height: 12),

                _buildInfoCard(
                  title: 'Gender',
                  value: user.gender ?? 'N/A',
                  icon: Icons.wc,
                ),
                const SizedBox(height: 24),

                // Physical Information Section
                const Text(
                  'Physical Information',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),

                _buildInfoCard(
                  title: 'Height',
                  value: user.height != null ? '${user.height} cm' : 'N/A',
                  icon: Icons.height,
                ),
                const SizedBox(height: 12),

                _buildInfoCard(
                  title: 'Weight',
                  value: user.weight != null ? '${user.weight} kg' : 'N/A',
                  icon: Icons.monitor_weight,
                ),
                const SizedBox(height: 12),

                _buildInfoCard(
                  title: 'Blood Group',
                  value: user.bloodGroup ?? 'N/A',
                  icon: Icons.bloodtype,
                ),
                const SizedBox(height: 12),

                _buildInfoCard(
                  title: 'Eye Color',
                  value: user.eyeColor ?? 'N/A',
                  icon: Icons.remove_red_eye,
                ),
                const SizedBox(height: 12),

                if (user.hair != null)
                  _buildInfoCard(
                    title: 'Hair',
                    value:
                        '${user.hair!.color ?? 'N/A'} - ${user.hair!.type ?? 'N/A'}',
                    icon: Icons.face,
                  ),
                const SizedBox(height: 24),

                // Address Information
                if (user.address != null) ...[
                  const Text(
                    'Address Information',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  Card(
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user.address!.address ?? 'N/A',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '${user.address!.city ?? 'N/A'}, ${user.address!.state ?? 'N/A'} ${user.address!.postalCode ?? ''}',
                            style: const TextStyle(fontSize: 14),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            user.address!.country ?? 'N/A',
                            style: const TextStyle(fontSize: 14),
                          ),
                          if (user.address!.coordinates != null)
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(
                                'Coordinates: ${user.address!.coordinates!.lat}, ${user.address!.coordinates!.lng}',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],

                // Company Information
                if (user.company != null) ...[
                  const Text(
                    'Company Information',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  _buildInfoCard(
                    title: 'Company',
                    value: user.company!.name ?? 'N/A',
                    icon: Icons.business,
                  ),
                  const SizedBox(height: 12),
                  _buildInfoCard(
                    title: 'Title',
                    value: user.company!.title ?? 'N/A',
                    icon: Icons.work,
                  ),
                  const SizedBox(height: 12),
                  _buildInfoCard(
                    title: 'Department',
                    value: user.company!.department ?? 'N/A',
                    icon: Icons.apartment,
                  ),
                  const SizedBox(height: 24),
                ],

                // Education
                _buildInfoCard(
                  title: 'University',
                  value: user.university ?? 'N/A',
                  icon: Icons.school,
                ),
                const SizedBox(height: 24),

                // Bank Information (Expandable)
                if (user.bank != null)
                  ExpansionTile(
                    title: const Text('Bank Information'),
                    leading: const Icon(Icons.credit_card),
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildDetailRow(
                              'Card Type',
                              user.bank!.cardType ?? 'N/A',
                            ),
                            _buildDetailRow(
                              'Card Number',
                              user.bank!.cardNumber ?? 'N/A',
                            ),
                            _buildDetailRow(
                              'Card Expire',
                              user.bank!.cardExpire ?? 'N/A',
                            ),
                            _buildDetailRow(
                              'Currency',
                              user.bank!.currency ?? 'N/A',
                            ),
                            _buildDetailRow('IBAN', user.bank!.iban ?? 'N/A'),
                          ],
                        ),
                      ),
                    ],
                  ),
                const SizedBox(height: 12),

                // Crypto Information (Expandable)
                if (user.crypto != null)
                  ExpansionTile(
                    title: const Text('Crypto Information'),
                    leading: const Icon(Icons.currency_bitcoin),
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildDetailRow('Coin', user.crypto!.coin ?? 'N/A'),
                            _buildDetailRow(
                              'Wallet',
                              user.crypto!.wallet ?? 'N/A',
                            ),
                            _buildDetailRow(
                              'Network',
                              user.crypto!.network ?? 'N/A',
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                const SizedBox(height: 12),

                // Technical Information (Expandable)
                ExpansionTile(
                  title: const Text('Technical Information'),
                  leading: const Icon(Icons.computer),
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildDetailRow(
                            'User ID',
                            user.id?.toString() ?? 'N/A',
                          ),
                          _buildDetailRow('Role', user.role ?? 'N/A'),
                          _buildDetailRow('IP Address', user.ip ?? 'N/A'),
                          _buildDetailRow(
                            'MAC Address',
                            user.macAddress ?? 'N/A',
                          ),
                          _buildDetailRow('EIN', user.ein ?? 'N/A'),
                          _buildDetailRow('SSN', user.ssn ?? 'N/A'),
                          const SizedBox(height: 8),
                          const Text(
                            'User Agent:',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            user.userAgent ?? 'N/A',
                            style: const TextStyle(fontSize: 11),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTokenRow(String label, String token, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    token.length > 50 ? '${token.substring(0, 50)}...' : token,
                    style: const TextStyle(
                      fontSize: 11,
                      fontFamily: 'monospace',
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.copy, size: 20),
              onPressed: () {
                Clipboard.setData(ClipboardData(text: token));
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('$label copied!'),
                    duration: const Duration(seconds: 1),
                  ),
                );
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildInfoCard({
    required String title,
    required String value,
    required IconData icon,
  }) {
    return Card(
      elevation: 2,
      child: ListTile(
        leading: Icon(icon, color: Colors.blue),
        title: Text(
          title,
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
        subtitle: Text(
          value,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
          ),
          Expanded(child: Text(value, style: const TextStyle(fontSize: 14))),
        ],
      ),
    );
  }
}
